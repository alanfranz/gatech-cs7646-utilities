buffet-make:
	rsync -arz --delete src buffet:
	ssh buffet 'rm -rf $${HOME}/run && mkdir $${HOME}/run && cd $${HOME}/run && ls ../src/*.zip | xargs -L1 unzip -q'

martingale-run:
	scp martingale/martingale.py buffet:run/
	ssh buffet 'cd run && python martingale.py'

optimize: buffet-make
	scp ML4T_2019Spring/optimize_something/optimization.py buffet:run/optimize_something/optimization.py
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd optimize_something && PYTHONPATH="..:." python optimization.py && PYTHONPATH="..:." python grade_optimization.py'

assess_learners_things: buffet-make
	cd ML4T_2019Spring/assess_learners ; rsync -az RTLearner.py DTLearner.py InsaneLearner.py BagLearner.py testlearner.py buffet:run/assess_learners/

grade_learners: assess_learners_things
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd assess_learners && PYTHONPATH="..:." python grade_learners.py'

testlearner: assess_learners_things
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd assess_learners && PYTHONPATH="..:." time python testlearner.py'

grade_best4: buffet-make
	cd ML4T_2019Spring/defeat_learners ; rsync -az DTLearner.py gen_data.py testbest4.py buffet:run/defeat_learners/
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd defeat_learners && PYTHONPATH="..:." python testbest4.py && PYTHONPATH="..:." time python grade_best4.py'

grade_marketsim: buffet-make
	cd ML4T_2019Spring/marketsim ; rsync -az marketsim.py buffet:run/marketsim/
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd marketsim && PYTHONPATH="..:." time python marketsim.py orders/orders-01.csv && PYTHONPATH="..:." time python grade_marketsim.py'

grade_robot_qlearning: buffet-make
	cd ML4T_2019Spring/qlearning_robot ; rsync -az QLearner.py testqlearner.py buffet:run/qlearning_robot/
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd qlearning_robot && PYTHONPATH="..:." time python grade_robot_qlearning.py'

grade_strategy_learner: buffet-make
	cd ML4T_2019Spring/strategy_learner ; rsync -az StrategyLearner.py buffet:run/strategy_learner/
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd strategy_learner && PYTHONPATH="..:." time python grade_strategy_learner.py'

StrategyLearner: buffet-make
	cd ML4T_2019Spring/strategy_learner ; rsync -az StrategyLearner.py buffet:run/strategy_learner/
	ssh buffet 'cd run && find -name "*.pyc" -delete && find -name "*.pyo" -delete && cd strategy_learner && PYTHONPATH="..:." time python StrategyLearner.py'
