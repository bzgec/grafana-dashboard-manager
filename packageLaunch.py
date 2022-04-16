from grafana_dashboard_manager.__main__ import main
import grafana_dashboard_manager.dashboard_download as dashboard_download
import grafana_dashboard_manager.dashboard_upload as dashboard_upload
import getopt
import sys


def displayHelp():
    print("""\
Import or export Grafana dashboards.

Tested with python 3.10.4

How to use:
  make SCRIPT_PARAM="[OPTIONS]"
or
  python packageLaunch.py [OPTIONS]

""")
    with open("helpOptions.txt", "r") as file:
        print(file.read())


def checkArgs(handle, argv):  # noqa: C901
    shortopts = "u:p:f:cei"
    longopts = [
        "help",
        "host=",
        "user=",
        "pass=",
        "folder=",
        "selfSignedCert=",
        "export",
        "import",
    ]

    try:
        opts, args = getopt.getopt(argv, shortopts, longopts)
    except getopt.GetoptError:
        displayHelp()
        sys.exit(1)

    for opt, arg in opts:
        if opt in ("--help"):
            displayHelp()
            sys.exit(0)
        elif opt in ("-h", "--host"):
            handle["host"] = arg
        elif opt in ("-u", "--user"):
            handle["user"] = arg
        elif opt in ("-p", "--pass"):
            handle["pass"] = arg
        elif opt in ("-f", "--folder"):
            handle["folder"] = arg
        elif opt in ("-c", "--selfSignedCert"):
            handle["selfSignedCert"] = True
        elif opt in ("-e", "--export"):
            handle["export"] = True
        elif opt in ("-i", "--import"):
            handle["import"] = True


if __name__ == "__main__":
    handle = {
        "host": "",
        "user": "",
        "pass": "",
        "selfSignedCert": False,
        "folder": "",
        "export": False,
        "import": False,
    }

    if len(sys.argv) > 1:
        checkArgs(handle, sys.argv[1:])
    else:
        displayHelp()
        sys.exit(0)

    # main("https://grafana.localhost", "test", "test", True, False)
    main(handle["host"], handle["user"], handle["pass"], handle["selfSignedCert"], False)

    if handle["export"]:
        dashboard_download.all(handle["folder"])

    if handle["import"]:
        dashboard_upload.all(handle["folder"])
