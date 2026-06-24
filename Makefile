DOCKER_IMAGE := zmkfirmware/zmk-dev-arm:stable
BOARD := nice_nano_v2
DOCKER_RUN := docker run --rm -v "$(shell pwd):/config:ro" -v "$(shell pwd)/output:/output" $(DOCKER_IMAGE)
WEST_SETUP := mkdir -p /workspace && cp -r /config/config /workspace/config && \
	west init -l /workspace/config && \
	cd /workspace && west update && \
	export ZEPHYR_BASE=/workspace/zephyr

.PHONY: all left right clean

all: left right

left: output/corne_left.uf2

right: output/corne_right.uf2

output/corne_left.uf2:
	@mkdir -p output
	$(DOCKER_RUN) bash -c "$(WEST_SETUP) && \
		cd /workspace/zmk/app && \
		west build -b $(BOARD) -- -DSHIELD='corne_left nice_view_adapter nice_view' -DZMK_CONFIG=/workspace/config && \
		cp build/zephyr/zmk.uf2 /output/corne_left.uf2"

output/corne_right.uf2:
	@mkdir -p output
	$(DOCKER_RUN) bash -c "$(WEST_SETUP) && \
		cd /workspace/zmk/app && \
		west build -b $(BOARD) -- -DSHIELD='corne_right nice_view_adapter nice_view' -DZMK_CONFIG=/workspace/config && \
		cp build/zephyr/zmk.uf2 /output/corne_right.uf2"

clean:
	rm -rf output
