# mago3D 설치 가이드

---

이 문서는 mago3D를 Docker Compose 및 Docker Stack을 이용하여 설치하는 방법을 안내합니다.

## 사전 준비 사항
* Docker와 Docker Compose가 설치된 환경
* Docker Swarm이 활성화된 환경 (Docker Stack 설치 시 필요)

## 1. Docker Compose를 이용한 설치
### 1.1 Docker Compose 파일 작성
아래의 내용을 복사하여 `docker-compose.yml` 파일을 작성합니다.
내용을 보고 환경에 맞도록 수정한 뒤 저장합니다.

```yaml


```

### 1.2 Docker Compose 실행
작성한 `docker-compose.yml` 파일이 있는 디렉토리로 이동하여 아래의 명령어를 실행합니다.

```bash
docker-compose up -d
```


## 2. Docker Stack을 이용한 설치
### 2.1 Docker Stack 파일 작성
아래의 내용을 복사하여 `docker-stack.yml` 파일을 작성합니다.
내용을 보고 환경에 맞도록 수정한 뒤 저장합니다.

```yaml

```

### 2.2 Docker Stack 배포
작성한 `docker-stack.yml` 파일이 있는 디렉토리로 이동하여 아래의 명령어를 실행합니다.

```bash
docker stack deploy -c docker-stack.yml mago3d
```
