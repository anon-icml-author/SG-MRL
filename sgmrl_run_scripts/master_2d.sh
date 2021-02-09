#!/bin/bash

module load anaconda/2020b

DIR="<PROJECT DIRECTORY (deleted for anonymity)>/sgmrl_experiments/"
MUJOCO_DIR="~/.mujoco/"

cd $DIR

ALGO=$1
ENV=$2
N_ADAPT_STEPS=$3
SEED=$4
SEED_TWO=$(( $SEED+100 ))
SEED_THREE=$(( $SEED+200 ))
SEED_FOUR=$(( $SEED+300 ))
SEED_FIVE=$(( $SEED+400 ))
SERVER=$5

printf "algo: $ALGO\n"
printf "env: $ENV\n"
printf "n_adapt_steps: $N_ADAPT_STEPS\n"
printf "seed: $SEED\n"
printf "seed second stage: $SEED_TWO\n"
printf "server: $SERVER\n"

LOGFILE="../logs/log-$ALGO-$ENV-seed-$SEED-n_adapt-$N_ADAPT_STEPS"
LOGFILE_TWO="../logs/log-$ALGO-$ENV-seed-$SEED_TWO-n_adapt-$N_ADAPT_STEPS"
LOGFILE_THREE="../logs/log-$ALGO-$ENV-seed-$SEED_THREE-n_adapt-$N_ADAPT_STEPS"
LOGFILE_FOUR="../logs/log-$ALGO-$ENV-seed-$SEED_FOUR-n_adapt-$N_ADAPT_STEPS"
LOGFILE_FIVE="../logs/log-$ALGO-$ENV-seed-$SEED_FIVE-n_adapt-$N_ADAPT_STEPS"
TMUX_SESSION="$ALGO-$ENV-n_adapt-$N_ADAPT_STEPS"

tmux new -d -s $TMUX_SESSION "python vpg_run.py --seed $SEED \
                          --env point \
                          --config /sgmrl_configs/sgmrl_quick.json \
                          --n_adapt_steps $N_ADAPT_STEPS \
                          --algo $ALGO \
                          > $LOGFILE 2>&1; \
                  wait $!; \
                  cd $MUJOCO_DIR; cp mjkey-$SERVER mjkey.txt; cd $DIR;
                  python vpg_run.py --seed $SEED_TWO \
                          --env point \
                          --config /sgmrl_configs/sgmrl_full.json \
                          --n_adapt_steps $N_ADAPT_STEPS \
                          --algo $ALGO \
                          > $LOGFILE_TWO 2>&1; \
                  wait $!; \
                  cd $MUJOCO_DIR; cp mjkey-$SERVER mjkey.txt; cd $DIR;
                  python vpg_run.py --seed $SEED_THREE \
                          --env point \
                          --config /sgmrl_configs/sgmrl_full.json \
                          --n_adapt_steps $N_ADAPT_STEPS \
                          --algo $ALGO \
                          > $LOGFILE_THREE 2>&1; \
                  wait $!; \
                  cd $MUJOCO_DIR; cp mjkey-$SERVER mjkey.txt; cd $DIR;
                  python vpg_run.py --seed $SEED_FOUR \
                          --env point \
                          --config /sgmrl_configs/sgmrl_full.json \
                          --n_adapt_steps $N_ADAPT_STEPS \
                          --algo $ALGO \
                          > $LOGFILE_FOUR 2>&1; \
                  wait $!; \
                  cd $MUJOCO_DIR; cp mjkey-$SERVER mjkey.txt; cd $DIR;
                  python vpg_run.py --seed $SEED_FIVE \
                          --env point \
                          --config /sgmrl_configs/sgmrl_full.json \
                          --n_adapt_steps $N_ADAPT_STEPS \
                          --algo $ALGO \
                          > $LOGFILE_FIVE 2>&1"
