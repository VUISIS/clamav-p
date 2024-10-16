# P model of ClamAV 0.94 untar

This project contains a model of a flawed ClamAV 0.94
implementation of Untar that can be tricked into an infinite loop,
essentialy disabling ClamAV. It also contains a fixed version, and
verifies that the infinite loop cannot occur.

Make sure you have a recent version of .NET installed and that
you have the P language, which can be installed with:

```bash
dotnet tool install --global P
```

Also make sure you have a recent version of Java and
that the Maven program is in your path. You can download
Maven from https://maven.apache.org/

To compile the project:

```bash
p compile
```

Unlike typical P projects where you use the `p check` command, this
project uses the PSym model checker that runs with Java. Once you compile
the project, it generates a Java jar file that you can run this way
(including the -st dfs option to use depth-first search, and -s 0 to use
an infinite number of schedules):

```bash
java -jar PGenerated/Symbolic/target/Clamav-jar-with-dependencies.jar -tc finishes -st dfs -s 0
```

The `-tc finishes` runs the test case that the flawed version finishes, and it
will indicate that it can find a counter-example. The following command runs the
test case to verify that the fixed version does not contain an infinite loop.
It may take an hour or more to complete:

```bash
java -jar PGenerated/Symbolic/target/Clamav-jar-with-dependencies.jar -tc fixFinishes -st dfs -s 0
```
