import 'dart:convert';

/// Messages sent from the sync service.
sealed class StreamingSyncLine {
  const StreamingSyncLine();

  /// Parses a [StreamingSyncLine] from JSON.
  static StreamingSyncLine fromJson(Map<String, dynamic> line) {
    if (line.containsKey('checkpoint')) {
      return Checkpoint.fromJson(line['checkpoint']);
    } else if (line.containsKey('checkpoint_diff')) {
      return StreamingSyncCheckpointDiff.fromJson(line['checkpoint_diff']);
    } else if (line.containsKey('checkpoint_complete')) {
      return StreamingSyncCheckpointComplete.fromJson(
          line['checkpoint_complete']);
    } else if (line.containsKey('partial_checkpoint_complete')) {
      return StreamingSyncCheckpointPartiallyComplete.fromJson(
          line['partial_checkpoint_complete']);
    } else if (line.containsKey('data')) {
      return SyncBucketData.fromJson(line['data']);
    } else if (line.containsKey('token_expires_in')) {
      return StreamingSyncKeepalive.fromJson(line);
    } else {
      return UnknownSyncLine(line);
    }
  }
}

/// A message from the sync service that this client doesn't support.
final class UnknownSyncLine implements StreamingSyncLine {
  final Map<String, dynamic> rawData;

  const UnknownSyncLine(this.rawData);
}

/// Indicates that a checkpoint is available, along with checksums for each
/// bucket in the checkpoint.
///
/// Note: Called `StreamingSyncCheckpoint` in sync-service.
final class Checkpoint extends StreamingSyncLine {
  final String lastOpId;
  final String? writeCheckpoint;
  final List<BucketChecksum> checksums;

  const Checkpoint(
      {required this.lastOpId, required this.checksums, this.writeCheckpoint});

  Checkpoint.fromJson(Map<String, dynamic> json)
      : lastOpId = json['last_op_id'],
        writeCheckpoint = json['write_checkpoint'],
        checksums = (json['buckets'] as List)
            .map((b) => BucketChecksum.fromJson(b))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'last_op_id': lastOpId,
      'write_checkpoint': writeCheckpoint,
      'buckets': checksums
          .map((c) => {'bucket': c.bucket, 'checksum': c.checksum})
          .toList(growable: false)
    };
  }
}

typedef BucketDescription = ({String name, int priority});

class BucketChecksum {
  final String bucket;
  final int priority;
  final int checksum;

  /// Count is informational only
  final int? count;
  final String? lastOpId;

  const BucketChecksum(
      {required this.bucket,
      required this.priority,
      required this.checksum,
      this.count,
      this.lastOpId});

  BucketChecksum.fromJson(Map<String, dynamic> json)
      : bucket = json['bucket'],
        priority = json['priority'],
        checksum = json['checksum'],
        count = json['count'],
        lastOpId = json['last_op_id'];
}

/// A variant of [Checkpoint] that may be sent when the server has already sent
/// a [Checkpoint] message before.
///
/// It has the same conceptual meaning as a [Checkpoint] message, but only
/// contains details about changed buckets as an optimization.
final class StreamingSyncCheckpointDiff extends StreamingSyncLine {
  String lastOpId;
  List<BucketChecksum> updatedBuckets;
  List<String> removedBuckets;
  String? writeCheckpoint;

  StreamingSyncCheckpointDiff(
      this.lastOpId, this.updatedBuckets, this.removedBuckets);

  StreamingSyncCheckpointDiff.fromJson(Map<String, dynamic> json)
      : lastOpId = json['last_op_id'],
        writeCheckpoint = json['write_checkpoint'],
        updatedBuckets = (json['updated_buckets'] as List)
            .map((e) => BucketChecksum.fromJson(e))
            .toList(),
        removedBuckets = List<String>.from(json['removed_buckets']);
}

/// Sent after the last [SyncBucketData] message for a checkpoint.
///
/// Since this indicates that we may have a consistent view of the data, the
/// client may make previous [SyncBucketData] rows visible to the application
/// at this point.
final class StreamingSyncCheckpointComplete extends StreamingSyncLine {
  String lastOpId;

  StreamingSyncCheckpointComplete(this.lastOpId);

  StreamingSyncCheckpointComplete.fromJson(Map<String, dynamic> json)
      : lastOpId = json['last_op_id'];
}

/// Sent after all the [SyncBucketData] messages for a given priority within a
/// checkpoint have been sent.
final class StreamingSyncCheckpointPartiallyComplete extends StreamingSyncLine {
  String lastOpId;
  int bucketPriority;

  StreamingSyncCheckpointPartiallyComplete(this.lastOpId, this.bucketPriority);

  StreamingSyncCheckpointPartiallyComplete.fromJson(Map<String, dynamic> json)
      : lastOpId = json['last_op_id'],
        bucketPriority = json['priority'];
}

/// Sent as a periodic ping to keep the connection alive and to notify the
/// client about the remaining lifetime of the JWT.
///
/// When the token is nearing its expiry date, the client may ask for another
/// one and open a new sync session with that token.
final class StreamingSyncKeepalive extends StreamingSyncLine {
  int tokenExpiresIn;

  StreamingSyncKeepalive(this.tokenExpiresIn);

  StreamingSyncKeepalive.fromJson(Map<String, dynamic> json)
      : tokenExpiresIn = json['token_expires_in'];
}

class StreamingSyncRequest {
  List<BucketRequest> buckets;
  bool includeChecksum = true;
  String clientId;
  Map<String, dynamic>? parameters;

  StreamingSyncRequest(this.buckets, this.parameters, this.clientId);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'buckets': buckets,
      'include_checksum': includeChecksum,
      'raw_data': true,
      'client_id': clientId
    };

    if (parameters != null) {
      json['parameters'] = parameters;
    }

    return json;
  }
}

class BucketRequest {
  String name;
  String after;

  BucketRequest(this.name, this.after);

  Map<String, dynamic> toJson() => {
        'name': name,
        'after': after,
      };
}

final class SyncBucketData extends StreamingSyncLine {
  final String bucket;
  final List<OplogEntry> data;
  final bool hasMore;
  final String? after;
  final String? nextAfter;

  const SyncBucketData(
      {required this.bucket,
      required this.data,
      this.hasMore = false,
      this.after,
      this.nextAfter});

  SyncBucketData.fromJson(Map<String, dynamic> json)
      : bucket = json['bucket'],
        hasMore = json['has_more'] ?? false,
        after = json['after'],
        nextAfter = json['next_after'],
        data =
            (json['data'] as List).map((e) => OplogEntry.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    return {
      'bucket': bucket,
      'has_more': hasMore,
      'after': after,
      'next_after': nextAfter,
      'data': data
    };
  }
}

class OplogEntry {
  final String opId;

  final OpType? op;

  /// rowType + rowId uniquely identifies an entry in the local database.
  final String? rowType;
  final String? rowId;

  /// Together with rowType and rowId, this uniquely identifies a source entry
  /// per bucket in the oplog. There may be multiple source entries for a single
  /// "rowType + rowId" combination.
  final String? subkey;

  final String? data;
  final int checksum;

  const OplogEntry(
      {required this.opId,
      required this.op,
      this.subkey,
      this.rowType,
      this.rowId,
      this.data,
      required this.checksum});

  OplogEntry.fromJson(Map<String, dynamic> json)
      : opId = json['op_id'],
        op = OpType.fromJson(json['op']),
        rowType = json['object_type'],
        rowId = json['object_id'],
        checksum = json['checksum'],
        data = json['data'] is String ? json['data'] : jsonEncode(json['data']),
        subkey = json['subkey'] is String ? json['subkey'] : null;

  Map<String, dynamic>? get parsedData {
    return data == null ? null : jsonDecode(data!);
  }

  /// Key to uniquely represent a source entry in a bucket.
  /// This is used to supersede old entries.
  /// Relevant for put and remove ops.
  String get key {
    return "$rowType/$rowId/$subkey";
  }

  Map<String, dynamic> toJson() {
    return {
      'op_id': opId,
      'op': op?.toJson(),
      'object_type': rowType,
      'object_id': rowId,
      'checksum': checksum,
      'subkey': subkey,
      'data': data
    };
  }
}

enum OpType {
  clear(1),
  move(2),
  put(3),
  remove(4);

  final int value;

  const OpType(this.value);

  static OpType? fromJson(String json) {
    switch (json) {
      case 'CLEAR':
        return clear;
      case 'MOVE':
        return move;
      case 'PUT':
        return put;
      case 'REMOVE':
        return remove;
      default:
        return null;
    }
  }

  String toJson() {
    switch (this) {
      case clear:
        return 'CLEAR';
      case move:
        return 'MOVE';
      case put:
        return 'PUT';
      case remove:
        return 'REMOVE';
    }
  }
}
