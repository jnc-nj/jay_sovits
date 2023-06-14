FROM nvcr.io/nvidia/tensorrt:22.04-py3

RUN git clone https://github.com/svc-develop-team/so-vits-svc
RUN cd so-vits-svc && pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]

# docker run -it --rm --gpus 1 -p 7860:7860 -p 7861:7861 --entrypoint /bin/bash -v /data/jay/dataset_raw:/workspace/so-vits-svc/dataset_raw -v /data/jay/logs:/workspace/so-vits-svc/logs -v /data/jay/pretrain:/workspace/so-vits-svc/pretrain -v /data/jay/configs:/workspace/so-vits-svc/configs -v /data/jay/dataset:/workspace/so-vits-svc/dataset -v /data/jay/filelists:/workspace/so-vits-svc/filelists -v /data/stable-diffusion-webui-docker/data/jay_input:/workspace/so-vits-svc/raw -v /data/stable-diffusion-webui-docker/data/jay_output:/workspace/so-vits-svc/results --shm-size=512M sovits 

# python train.py -c configs/config.json -m 44k
# python train_diff.py -c configs/diffusion.yaml

# python inference_main.py -m "logs/44k/G_200000.pth" -c "configs/config.json" -shd -dm "logs/44k/diffusion/model_450000.pt" -dc "configs/diffusion.yaml" -fr -cm "logs/44k/feature_and_index.pkl" -s "jay" -cr 0.5 -lea 0.5 -f0p "crepe" -cl 25 -t 0 -a -ns 0.4 -lg 1 -ks 1000 -sd -30 -ft 0.001 -wf "wav" -n "test_f_1.wav"

# tensorboard --logdir logs --bind_all --port 7860
# tensorboard --logdir logs/44k/diffusion/logs --bind_all --port 7861

# for f in raw/*.wav; do python inference_main.py -m "logs/44k/G_200000.pth" -c "configs/config.json" -shd -dm "logs/44k/diffusion/model_450000.pt" -dc "configs/diffusion.yaml" -fr -cm "logs/44k/feature_and_index.pkl" -s "jay" -cr 0.5 -lea 0.5 -f0p "crepe" -cl 25 -t 0 -a -ns 0.4 -lg 1 -ks 1000 -sd -30 -ft 0.001 -wf "wav" -n "$(basename $f)"

# for f in *.flac; do ffmpeg -y -i "$(basename $f)" -af 'asetrate=44100*95/100,atempo=100/95' "$(basename $f).wav"
