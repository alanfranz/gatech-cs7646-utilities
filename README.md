# gatech-cs7646-utilities
Some utilities for working better with Gatech ML4T - CS7646 assignments

This is kind of a template. **THIS REPOSITORY CONTAINS NO CODE COPYRIGHTED BY GATECH AND NO SOLUTION TO EXERCISES**,
it's just a template to make automated testing on buffet easier.

Tested on Linux and Mac. This is great if you want to develop on your workstation but you need to test
results on the reference machines (buffet) in an automated way; just use a virtualenv with
the provided requirements.txt on your workstation, then use this Makefile to verify the results
on buffet.

You can read my 2c for ML4T [here](https://www.reddit.com/r/OMSCS/comments/biqvgr/succeeding_in_cs7646_ml4t_my_2c/)

## How to use this?

First, create an entry in your ```.ssh/config``` and add a ```buffet``` entry for automatic access
to your buffet machine. Make sure you've enabled ssh-key automatic, no-password access.
Take a look at the Makefile. You want to run scripts remotely in an unattended and predictable way. Something like:

```
Host buffet
   Hostname buffet99.cc.gatech.edu
   User gatechuserid123
```

Should work.

Then, make sure ```rsync``` is installed on your local machine.

You should add the code templates which are course provided (usually .zip files) and put those "vanilla" zips in the ```src```
directory. This way the code will be unpacked remotely ```each time you call a make target```. It may seem 
time consuming, but it makes sure that you're testing against the correct files each time. That part is performed
by the ```buffet-make``` target.

Then, there will be a root directory (here is ML4T_2019Spring) where all your project files will lie. Such directory path is
contained in the .zip files already. In order to test
your implementations on buffet, you should make sure your target copies **only the files you have worked on** in the matching
directory on buffet. Example with the "optimization" assignment:

```
optimize: buffet-make
	scp ML4T_2019Spring/optimize_something/optimization.py buffet:run/optimize_something/optimization.py
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd optimize_something && PYTHONPATH="..:." python optimization.py && PYTHONPATH="..:." python grade_optimization.py
```



This task copies ONLY my ```optimization.py``` file to the corresponding directory on buffet; such directory was freshly created
by ```buffet-make``` and contains vanilla files.
Then, possibly stale cache files are deleted, and both ```optimization.py``` (where you could put code in ```__main__``` for handwritten tests)
and ```grade_optimization.py``` (provided in the optimization zip file) are run with the libraries which are provided on buffet, and with the test
cases which are provided in the original zip files.

It is **very important that you only copy to buffet only (and all) the files you want to submit, and not other files (especially grading scripts)**,
because, otherwise, you could modify your environment in an unexpected way (e.g. you change something in the grading script locally to do some tests,
don't realize that, tests pass with your modified version but they actually crash with the "real" grading scripts).

When you run such target, your result is buffet-tested in quite a reproducibile way. This script is tuned to what happened in Spring 2019, you'll need
to change it for other terms.

Example output:

```
workstation:ml4t-projects user$ make optimize
rsync -arz --delete src buffet:
ssh buffet 'rm -rf ${HOME}/run && mkdir ${HOME}/run && cd ${HOME}/run && ls ../src/*.zip | xargs -L1 unzip -q'
scp ML4T_2019Spring/optimize_something/optimization.py buffet:run/optimize_something/optimization.py
optimization.py                                                                                              100%   12KB  44.6KB/s   00:00
ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd optimize_something && PYTHONPATH="..:." python optimization.py && PYTHONPATH="..:." python grade_optimization.py'
Start Date: 2008-06-01 00:00:00
End Date: 2009-06-01 00:00:00
Symbols: ['IBM', 'X', 'GLD', 'JPM']
Allocations: [  0.00000000e+00   1.11022302e-16   1.11022302e-16   1.00000000e+00]
Sharpe Ratio: 0.423107179242
Volatility (stdev of daily returns): 0.0689110688493
Average Daily Return: 0.0018367037394
Cumulative Return: -0.114809081527
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.2.1, py-1.4.34, pluggy-0.4.0
rootdir: /home/gatechuserid123/run/optimize_something, inifile:
collected 8 items

grade_optimization.py ........[GRADER] Writing points to "points.txt"...
[GRADER] Writing comments to "comments.txt"...

--- Summary ---
Tests passed: 8 out of 8

--- Details ---
Test #0: passed
Test #1: passed
Test #2: passed
Test #3: passed
Test #4: passed
Test #5: passed
Test #6: passed
Test #7: passed

No performance metric collected, skipping
[GRADER] Done!


=========================== 8 passed in 7.79 seconds ===========================
```

You can see the results of running my optimizer's ```__main__```, then running grade_optimization.py, all with the same paths and approaches
as suggested in ML4T documentation.

# Disclaimer

Your mileage may vary. Make sure you understand what you're doing.


