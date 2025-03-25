<p align="center">
  <a href="https://www.powersync.com" target="_blank"><img src="https://github.com/powersync-ja/.github/assets/7372448/d2538c43-c1a0-4c47-9a76-41462dba484f"/></a>
</p>

_[PowerSync](https://www.powersync.com) is a sync engine for building local-first apps with instantly-responsive UI/UX and simplified state transfer. Syncs between SQLite on the client-side and Postgres, MongoDB or MySQL on the server-side._

# PowerSync SDK for Dart and Flutter

| package                                                                                                                          | build                                                                                                                                                                                               | pub                                                                                                                                    | likes                                                                                                                                            | popularity                                                                                                                                                 | pub points                                                                                                                                             |
| -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [powersync](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync)                                       | [![build](https://github.com/powersync-ja/powersync.dart/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/powersync-ja/powersync.dart/actions?query=workflow%3Apackages) | [![pub package](https://img.shields.io/pub/v/powersync.svg)](https://pub.dev/packages/powersync)                                       | [![likes](https://img.shields.io/pub/likes/powersync?logo=dart)](https://pub.dev/packages/powersync/score)                                       | [![popularity](https://img.shields.io/pub/popularity/powersync?logo=dart)](https://pub.dev/packages/powersync/score)                                       | [![pub points](https://img.shields.io/pub/points/powersync?logo=dart)](https://pub.dev/packages/powersync/score)                                       |
| [powersync_core](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_core)                             | [![build](https://github.com/powersync-ja/powersync.dart/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/powersync-ja/powersync.dart/actions?query=workflow%3Apackages) | [![pub package](https://img.shields.io/pub/v/powersync_core.svg)](https://pub.dev/packages/powersync_core)                             | [![likes](https://img.shields.io/pub/likes/powersync_core?logo=dart)](https://pub.dev/packages/powersync_core/score)                             | [![popularity](https://img.shields.io/pub/popularity/powersync_core?logo=dart)](https://pub.dev/packages/powersync_core/score)                             | [![pub points](https://img.shields.io/pub/points/powersync_core?logo=dart)](https://pub.dev/packages/powersync_core/score)                             |
| [powersync_sqlcipher](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_sqlcipher)                   | [![build](https://github.com/powersync-ja/powersync.dart/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/powersync-ja/powersync.dart/actions?query=workflow%3Apackages) | [![pub package](https://img.shields.io/pub/v/powersync_sqlcipher.svg)](https://pub.dev/packages/powersync_sqlcipher)                   | [![likes](https://img.shields.io/pub/likes/powersync_sqlcipher?logo=dart)](https://pub.dev/packages/powersync_sqlcipher/score)                   | [![popularity](https://img.shields.io/pub/popularity/powersync_sqlcipher?logo=dart)](https://pub.dev/packages/powersync_sqlcipher/score)                   | [![pub points](https://img.shields.io/pub/points/powersync_sqlcipher?logo=dart)](https://pub.dev/packages/powersync_sqlcipher/score)                   |
| [powersync_attachments_helper](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_attachments_helper) | [![build](https://github.com/powersync-ja/powersync.dart/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/powersync-ja/powersync.dart/actions?query=workflow%3Apackages) | [![pub package](https://img.shields.io/pub/v/powersync_attachments_helper.svg)](https://pub.dev/packages/powersync_attachments_helper) | [![likes](https://img.shields.io/pub/likes/powersync_attachments_helper?logo=dart)](https://pub.dev/packages/powersync_attachments_helper/score) | [![popularity](https://img.shields.io/pub/popularity/powersync_attachments_helper?logo=dart)](https://pub.dev/packages/powersync_attachments_helper/score) | [![pub points](https://img.shields.io/pub/points/powersync_attachments_helper?logo=dart)](https://pub.dev/packages/powersync_attachments_helper/score) |
| [powersync_flutter_libs](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_flutter_libs)             | [![build](https://github.com/powersync-ja/powersync.dart/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/powersync-ja/powersync.dart/actions?query=workflow%3Apackages) | [![pub package](https://img.shields.io/pub/v/powersync_flutter_libs.svg)](https://pub.dev/packages/powersync_flutter_libs)             | [![likes](https://img.shields.io/pub/likes/powersync_flutter_libs?logo=dart)](https://pub.dev/packages/powersync_flutter_libs/score)             | [![popularity](https://img.shields.io/pub/popularity/powersync_flutter_libs?logo=dart)](https://pub.dev/packages/powersync_flutter_libs/score)             | [![pub points](https://img.shields.io/pub/points/powersync_flutter_libs?logo=dart)](https://pub.dev/packages/powersync_flutter_libs/score)             |

#### Usage

This monorepo uses [melos](https://melos.invertase.dev/) to handle command and package management.

For detailed usage, check out the inner [powersync](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync), [powersync_core](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_core), [powersync_sqlcipher](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_sqlcipher) and [attachments helper](https://github.com/powersync-ja/powersync.dart/tree/main/packages/powersync_attachments_helper) packages.

To configure the monorepo for development run `melos prepare` after cloning

#### Blog posts

- [Flutter Tutorial: building an offline-first chat app with Supabase and PowerSync](https://www.powersync.com/blog/flutter-tutorial-building-an-offline-first-chat-app-with-supabase-and-powersync)

#### Resources

- [![PowerSync docs](https://img.shields.io/badge/documentation-powersync.com-green.svg?label=flutter%20docs)](https://docs.powersync.com/client-sdk-references/flutter)
- [![Discord](https://img.shields.io/discord/1138230179878154300?style=social&logo=discord&logoColor=%235865f2&label=Join%20Discord%20server)](https://discord.gg/powersync)
- [![Twitter follow](https://img.shields.io/twitter/follow/powersync?label=PowerSync&style=social)](https://twitter.com/intent/follow?screen_name=powersync_)
- [![YouTube](https://img.shields.io/youtube/channel/subscribers/UCSDdZvrZuizmc2EMBuTs2Qg?style=social&label=YouTube%20%40powersync_)](https://twitter.com/intent/follow?screen_name=powersync_)
