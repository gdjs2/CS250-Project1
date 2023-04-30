import sys
import os
import time
import subprocess

# Fuzzing Helper
FUZZING_HELPER = '/src/symcc/util/symcc_fuzzing_helper/target/release/symcc_fuzzing_helper'
# SymQEMU
SYMQEMU = '/src/symqemu/build/x86_64-linux-user/symqemu-x86_64'
# AFL++
AFL = '/src/AFLplusplus/afl-fuzz'
# To-Test Binary Directory
BIN_DIR = '/shared/'
# AFL_OUT Directory
AFL_OUT_DIR = 'afl_out'
CORPUS_DIR = './corpus'

AFL_ENV = {
	'AFL_MAP_SIZE': '65536',
	'AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES': '1',
	'AFL_SKIP_CPUFREQ': '1'
}

if __name__ == '__main__':
	
	if len(sys.argv) != 2:
		print('Usage: python3 hybrid_fuzzing.py [target]')
		exit(0)

	target = sys.argv[1]
	target_path = os.path.join(BIN_DIR, target)

	if not os.path.exists(target_path):
		print('File {} does not exist!'.format(target_path))
		exit(0)

	if not os.path.exists(CORPUS_DIR):
		os.makedirs(CORPUS_DIR)
	with open(os.path.join(CORPUS_DIR, 'Dummy'), 'w') as dummy_input:
		dummy_input.write('A')
	
	# Run Master AFL++
	subprocess.Popen([AFL, '-Q', '-M', 'afl-master', '-i', 'corpus', '-o', AFL_OUT_DIR, '-m', 'none', '--', target_path, '&'], env=AFL_ENV, stdout=subprocess.DEVNULL)
	# Run Secondary AFL++
	# subprocess.Popen([AFL, '-Q', '-S', 'afl-secondary', '-i', 'corpus', '-o', AFL_OUT_DIR, '-m', 'none', '--', target_path, '&'], env=AFL_ENV, stdout=subprocess.DEVNULL)
	# time.sleep(2)
	# Run SymQEMU
	# subprocess.Popen([FUZZING_HELPER, '-o', AFL_OUT_DIR, '-a', 'afl-secondary', '-n', 'symqemu', '--', SYMQEMU, target_path], env=AFL_ENV, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)