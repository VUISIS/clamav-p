machine TestFinish {
  start state Init {
    entry {
      var untar: Untar;
      untar = new Untar();
    }
  }
}

machine TestFixFinish {
  start state Init {
    entry {
      var untar: UntarFix;
      untar = new UntarFix();
    }
  }
}
