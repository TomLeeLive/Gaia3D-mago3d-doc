# mago3D 설치 가이드

---

이 문서는 mago3D를 Docker Compose 및 Docker Stack을 이용하여 설치하는 방법을 안내합니다.

## 사전 준비 사항
* Docker가 설치된 환경
* localhost 인증서가 설치된 환경

Docker 데몬을 실행합니다.
Windows의 경우, Docker Desktop을 실행합니다.
Mac의 경우, Docker Desktop을 실행합니다.
Linux의 경우, Docker 서비스를 실행합니다.

### 인증서 설치 방법
[mkcert](https://github.com/FiloSottile/mkcert)를 사용하여 localhost 인증서를 생성합니다.

* winget   
  PS 터미널을 관리자 권한으로 실행하여 아래 명령을 실행한다.
  ```powershell
  winget install mkcert
  ```
* local CA 설치
  ```cmd
  mkcert -install
  ```
* 인증서 생성
  ```cmd
  cd install/infra/trafik/certs
  mkcert -cert-file default.crt -key-file default.key localhost dev.localhost *.localhost 127.0.0.1 ::1
  ```

## 1. Docker 이미지 로드
먼저, 배포된 Docker 이미지 파일을 install 경로에 복사합니다.
아래의 스크립트를 실행하여 관련된 Docker 이미지를 로드합니다.
```bash
cd install
./load_docker_images.sh
```

## 2. Docker Network 생성
아래의 명령어를 실행하여 Docker Network를 생성합니다.
```bash
docker network create mago3d
```

## 3. Docker Compose 배포
### 3.1. Infra 배포
```bash
cd install/infra
./compose.sh up -d
```
종료를 원하면 다음과 같은 명령어를 실행합니다.
```bash
./compose.sh down
```

### 3.2. Infra 설정
#### 1. Traefik Dashboard 접속
* http://dev.localhost/dashboard/  

#### 2. Keycloak 접속
* https://dev.localhost/auth/  
* 계정: admin/keycloak  
* mago3d realm 생성  
  `install/infra/auth-data/realm-export.json` 파일을 이용하여 realm을 생성합니다.  
  ```  
    master Select Box -> Create Realm -> upload realm-export.json -> create
  ```
* mago3d client 생성  
  `install/infra/auth-data/mago3d-api.json`, `install/infra/auth-data/mago3d-front.json` 파일을 이용하여 client를 생성합니다.  
  ```
    Select Box -> mago3d -> Clients -> Import client -> Upload mago3d-api.json -> Save  
    Select Box -> mago3d -> Clients -> Import client -> Upload mago3d-front.json -> Save
  ```  
* service account role 추가
  ```
    Select Box -> mago3d -> Clients -> mago3d-api -> Service account roles -> Assign role ->   
    Filter by clients -> select (realm-management) manage-users, (account) manage-account -> Assign
  ```
* mago3d user 생성
  ```
    Select Box -> mago3d ->  Users -> Add user
    Username: admin
    -> Save
  ```
* mago3d user password 설정
  ```
    Select Box -> mago3d -> Users -> admin -> Credentials -> Set password
    New password: admin
    Temporary: OFF
    -> Save
  ```
* mago3d user role 추가
  ```
    Select Box -> mago3d -> Users -> admin -> Role mapping
    Assign role -> select admin -> Assign
  ```

#### 3. ConfigRepo 접속
* http://dev.localhost/configrepo/
* 계정: git/git
* config 저장소 추가
* install/infra/config-data/ 하위에 있는 파일 업로드 및 커밋
* 각자 환경에 맞도록 설정 파일을 수정하고 커밋

#### 4. Geoserver 접속
* http://dev.localhost/geoserver/
* 계정: admin/geoserver
* Workspace 생성
  ```
    Workspace -> Add new workspace -> 
    Workspace Name: mago3d 
    Namespace URI: https://dev.localhost/geoserver/web/mago3d
    check Default Workspace 
    -> Save
  ```
* Store 생성
  ```
    Stores -> Add new Store -> Store Type: PostGIS ->
    Workspace: mago3d 
    Data Store Name: postgis 
    Connection Parameters:
      host: postgresql
      port: 5432
      database: postgres
      schema: geoserver
      user: postgres
      passwd: postgres
    -> Save
  ```


### 3.3. Apps 배포
```bash
cd install/apps
./compose.sh up -d
```
종료를 원하면 다음과 같은 명령어를 실행합니다.
```bash
./compose.sh down
```
