spec Finish observes eDone, eError, eVirus {
  start state Init {
    entry {
      goto Watch;
    }
  }

  hot state Watch {
    on eDone do {
      goto Success;
    }

    on eError do {
      goto Success;
    }

    on eVirus do {
      goto Success;
    }
  }

  state Success {

  }
}
