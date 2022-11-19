class Debugger:
    def __init__(self, verbose=True):
        self.verbose = verbose

    def rise_Error(self, msg):
        print("[ERROR] ", msg)

    def debug(self, msg):
        if self.verbose:
            print("[DEBUG] ", msg)