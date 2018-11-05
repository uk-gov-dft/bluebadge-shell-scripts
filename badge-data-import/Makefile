.PHONY: test
test: shunit2-2.1.7/ shellcheck-v0.5.0/
	./shellcheck-v0.5.0/shellcheck -x prepare_images.sh
	./prepare_images_test.sh

.PHONY: test_osx
test_osx: shunit2-2.1.7/ shell_check_osx
	shellcheck -x prepare_images.sh
	./prepare_images_test.sh

shunit2-2.1.7/:
	curl -s -L "https://github.com/kward/shunit2/archive/v2.1.7.tar.gz" | tar zx

shellcheck-v0.5.0/:
	curl -s -L -o /tmp/shellcheck-v0.5.0.linux.x86_64.tar.xz https://storage.googleapis.com/shellcheck/shellcheck-v0.5.0.linux.x86_64.tar.xz
	tar -xJf /tmp/shellcheck-v0.5.0.linux.x86_64.tar.xz -C ./

.PHONY: shell_check_osx
shell_check_osx:
	brew install shellcheck
