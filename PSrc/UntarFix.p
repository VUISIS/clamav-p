machine UntarFix
{
  var size: int;
  var ret: int;
  var fout: int;
  var in_block: bool;
  var files: int;
  var nread: int;
  var directory: bool;
  var skip_entry: bool;
  var typeVal: int;
  var nskip: int;
  var filepos: int;

  fun cli_magic_scandesc(): int {
    return choose(2);
  }

  start state Init {
    entry {
      size = 0;
      fout = -1;
      filepos = 0;
      in_block = false;

      goto Loop;
    }
  }

  state Loop {
    entry {
      skip_entry = false;
      directory = false;
      
      if (filepos >= 12) {
        nread = 0;
      } else {
        nread = -1 + choose(6);
      }

      if (!in_block && nread == 0) {
        goto Done;
      }

      if (nread < 0) {
        goto Error;
      }

      filepos = filepos + nread;

      if (!in_block) {
        if (fout >= 0) {
          ret = cli_magic_scandesc();
          if (ret == 1) {
            goto Virus;
          }
          fout = -1;
        }

        if (choose(2) == 0) {
          goto Done;
        }

        typeVal = choose (3);

        if (typeVal == 0) {
          files = 1;
          directory = false;
        } else if (typeVal == 1) {
          directory = true;
        } else if (typeVal == 2) {
          directory = false;
          skip_entry = true;
        }

        if (directory) {
          in_block = false;
          goto Loop;
        }

        size = -4 + choose(9);
        if (size < 0) {
          skip_entry = true;
        }

        if (skip_entry) {
          if (size % 4 != 0 || size == 0) {
            nskip = size + 4 - (size % 4);
          } else {
            nskip = size;
          }
          if (nskip < 0) {
            goto Done;
          }
          filepos = filepos + nskip;
          if (filepos > 12) {
            filepos = 12;
          } else if (filepos < 0) {
            filepos = 0;
          }
          goto Loop;
        }

        fout = 1;

        in_block = true;
        goto Loop;
      } else {
        size = size - (1 + choose(size));
        if (size <= 0) {
          in_block = false;
        }
        goto Loop;
      }
    }
  }

  state Done {
    entry {
      announce eDone;
    }
  }

  state Error {
    entry {
      announce eError;
    }
  }

  state Virus {
    entry {
      announce eVirus;
    }
  }
}
