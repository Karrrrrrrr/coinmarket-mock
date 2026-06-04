build-frontend:
	cd safeheron-frontend && pnpm build-only
	rm -rf dist && mv safeheron-frontend/dist ./


build-image:
	# docker buildx create --name multiarch-builder --use
	# 生成时间戳标签
	TIMESTAMP=$$(date +%Y%m%d%H%M%S); \
	docker buildx build --platform linux/amd64,linux/arm64 \
		--provenance=false \
		--sbom=false \
		-t swr.cn-north-4.myhuaweicloud.com/kar/coinmarket-mock:$$TIMESTAMP \
		--push . && \
	docker buildx build --platform linux/amd64,linux/arm64 \
		--provenance=false \
		--sbom=false \
		-t swr.cn-north-4.myhuaweicloud.com/kar/coinmarket-mock:latest \
		--push .