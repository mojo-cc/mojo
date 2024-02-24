# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #
# REQUIRES: !windows
# RUN: %mojo -debug-level full -D TEMP_FILE=%t %s

from pathlib import *
from sys.param_env import env_get_string

from testing import *

alias TEMP_FILE = env_get_string["TEMP_FILE"]()


def test_cwd():
    print("== test_cwd")

    # CHECK-NOT: unable to query the current directory
    assert_true(str(cwd()).startswith("/"))


def test_path():
    print("== test_path")

    assert_true(str(Path() / "some" / "dir").endswith("/some/dir"))

    assert_equal(str(Path("/foo") / "bar" / "jar"), "/foo/bar/jar")

    assert_equal(
        str(Path("/foo" + DIR_SEPARATOR) / "bar" / "jar"), "/foo/bar/jar"
    )

    assert_not_equal(Path().stat().st_mode, 0)

    assert_true(len(Path().listdir()) > 0)


def test_path_exists():
    print("== test_path_exists")

    assert_true(Path(__source_location().file_name).exists(), "does not exist")

    assert_false((Path() / "this_path_does_not_exist.mojo").exists(), "exists")


def test_path_isdir():
    print("== test_path_isdir")
    assert_true(Path().is_dir())
    assert_false((Path() / "this_path_does_not_exist").is_dir())


def test_path_isfile():
    print("== test_path_isfile")
    assert_true(Path(__source_location().file_name).is_file())
    assert_false(Path("this/file/does/not/exist").is_file())


def test_suffix():
    # Common filenames.
    assert_equal(Path("/file.txt").suffix(), ".txt")
    assert_equal(Path("file.txt").suffix(), ".txt")
    assert_equal(Path("file").suffix(), "")
    assert_equal(Path("my.file.txt").suffix(), ".txt")

    # Dot Files and Directories
    assert_equal(Path(".bashrc").suffix(), "")
    assert_equal(Path("my.folder/file").suffix(), "")
    assert_equal(Path("my.folder/.file").suffix(), "")

    # Special Characters in File Names
    assert_equal(Path("my file@2023.pdf").suffix(), ".pdf")
    assert_equal(Path("résumé.doc").suffix(), ".doc")


def test_joinpath():
    assert_equal(Path(), Path().joinpath())
    assert_equal(Path() / "some" / "dir", Path().joinpath("some", "dir"))


def test_read_write():
    Path(TEMP_FILE).write_text("hello")
    assert_equal(Path(TEMP_FILE).read_text(), "hello")


def main():
    test_cwd()
    test_path()
    test_path_exists()
    test_path_isdir()
    test_path_isfile()
    test_suffix()
    test_joinpath()
    test_read_write()
