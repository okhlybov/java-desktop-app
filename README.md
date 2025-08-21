## Build platform-specific image

Run the pass co create platform-specific app distribution

```shell
./gradlew jlink
```

If it (likely) fails complaining about cache problems, rerun with `--no-configuration-cache` option

```shell
./gradlew jlink --no-configuration-cache
```

# Assorted tips & info

* Global project version is set in `gradle.properties` file.