# mago3D 설치 가이드

---

이 문서는 mago3D를 Docker Compose 및 Docker Stack을 이용하여 설치하는 방법을 안내합니다.

## 사전 준비 사항
* Docker가 설치된 환경
* localhost 인증서가 설치된 환경
* git이 설치된 환경 (https://github.com/git-guides/install-git)

Docker 데몬을 실행합니다.  
Windows의 경우, Docker Desktop을 실행합니다.  
Mac의 경우, Docker Desktop을 실행합니다.  
Linux의 경우, Docker 서비스를 실행합니다.  

### 인증서 설치 방법
[mkcert](https://github.com/FiloSottile/mkcert)를 사용하여 localhost 인증서를 생성합니다.

* winget(Windows)    
  PS 터미널을 관리자 권한으로 실행하여 아래 명령을 실행한다.
  ```powershell
  winget install mkcert
  ```
* brew(macOS)
  ```bash
  brew install mkcert
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
혹시 실행 권한이 없다면 다음 구문을 실행
```bash
chmod +x load_docker_images.sh
./load_docker_images.sh
```

## 2. Docker Network 생성
아래의 명령어를 실행하여 Docker Network를 생성합니다.
```bash
docker network create mago3d
```

## 3. Terrain Data 복사
배포된 terrain 폴더를 install/infra/terrain-data 경로에 복사합니다.

## 4. Docker Compose 배포
### 4.1. Infra 배포
```bash
cd install/infra
./compose.sh up -d
```
혹시 실행 권한이 없다면 다음 구문을 실행
```bash
chmod +x *.sh
./compose.sh up -d
```
### 4.2. Infra 종료
종료를 원하면 다음과 같은 명령어를 실행합니다.
```bash
./compose.sh down
```

### 4.3. Infra 설정
#### 1. Traefik Dashboard
* http://dev.localhost/dashboard/  
![traefik.png](../../images/Installation_Guide/traefik.png)

#### 2. Keycloak
* https://dev.localhost/auth/
* Administration Console에 접속하여 다음과 같은 설정을 추가합니다.
![keycloak.png](../../images/Installation_Guide/keycloak.png)
* 계정: admin/keycloak
* mago3d realm 생성  
  `install/infra/auth-data/realm-export.json` 파일을 이용하여 realm을 생성합니다.  
  ```  
    master Select Box -> Create Realm -> upload realm-export.json -> create
  ```
  ![realm.png](../../images/Installation_Guide/realm.png)
* mago3d client 생성  
  `install/infra/auth-data/mago3d-api.json`, `install/infra/auth-data/mago3d-front.json` 파일을 이용하여 client를 생성합니다.  
  ```
    Select Box -> mago3d -> Clients -> Import client -> Upload mago3d-api.json -> Save  
    Select Box -> mago3d -> Clients -> Import client -> Upload mago3d-front.json -> Save
  ```  
  ![client.png](../../images/Installation_Guide/client.png)
  ![import-client.png](../../images/Installation_Guide/import-client.png)
  ![api-client.png](../../images/Installation_Guide/api-client.png)
* service account role 추가
  ```
    Select Box -> mago3d -> Clients -> mago3d-api -> Service account roles -> Assign role ->   
    Filter by clients -> select (realm-management) manage-users, (account) manage-account -> Assign
  ```
  ![assign-role.png](../../images/Installation_Guide/assign-role.png)
  ![service-account-role.png](../../images/Installation_Guide/service-account-role.png)
  
* mago3d user 생성
  ```
    Select Box -> mago3d ->  Users -> Add user
    Username: admin
    First Name: admin
    -> Create
  ```
  ![add-user.png](../../images/Installation_Guide/add-user.png)
  ![user.png](../../images/Installation_Guide/user.png)
* mago3d user password 설정
  ```
    Select Box -> mago3d -> Users -> admin -> Credentials -> Set password
    New password: admin
    Temporary: OFF
    -> Save password
  ```
  ![password.png](../../images/Installation_Guide/password.png)
* mago3d user role 추가
  ```
    Select Box -> mago3d -> Users -> admin -> Role mapping
    Assign role -> select admin -> Assign
  ```
  ![role-mapping.png](../../images/Installation_Guide/role-mapping.png)

#### 3. ConfigRepo
* http://dev.localhost/configrepo/
![configrepo.png](../../images/Installation_Guide/configrepo.png)
* 계정: git/git
* config 저장소 추가
![add-repo.png](../../images/Installation_Guide/add-repo.png)
![create-repo.png](../../images/Installation_Guide/create-repo.png)
* install/infra/config-data/ 하위에 있는 파일 업로드 및 커밋
```
cd install/infra/config-data
git init
git checkout -b main
git add .
git commit -m "first commit"
git remote add origin https://dev.localhost/configrepo/git/config.git
git push -u origin main
```
* 각자 환경에 맞도록 설정 파일을 수정하고 커밋

#### 4. Geoserver
* http://dev.localhost/geoserver/
![geoserver.png](../../images/Installation_Guide/geoserver.png)
* 계정: admin/geoserver
* Workspace 생성
  ```
    Workspace -> Add new workspace -> 
    Workspace Name: mago3d 
    Namespace URI: https://dev.localhost/geoserver/web/mago3d
    check Default Workspace 
    -> Save
  ```
  ![workspace.png](../../images/Installation_Guide/workspace.png)
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
  ![store.png](../../images/Installation_Guide/store.png)
  ![store-connection.png](../../images/Installation_Guide/store-connection.png)

#### 5. Grafana
* http://dev.localhost/grafana/   
![grafana.png](../../images/Installation_Guide/grafana.png)
* 계정: admin/admin
* Datasource 추가
  ```
    Configuration -> Data Sources -> Add data source -> Prometheus -> Select
    Name: Prometheus
    URL: http://prometheus:9090
    -> Save & Test
  ```
  ![datasource.png](../../images/Installation_Guide/datasource.png)
  ![datasource-prometheus.png](../../images/Installation_Guide/datasource-prometheus.png)
  ![prometheus-connection.png](../../images/Installation_Guide/prometheus-connection.png)
  ![prometheus-connection.png](../../images/Installation_Guide/prometheus-connection.png)
* Dashboard 추가
* `install/infra/dashboard/jvm-micrometer.json` 파일을 이용하여 dashboard를 추가합니다.
  ```
    + -> Import -> Upload JSON File -> jvm-micrometer.json -> Import
  ```
  ![dashboard.png](../../images/Installation_Guide/dashboard.png)
  ![import-dashboard.png](../../images/Installation_Guide/import-dashboard.png)
  ![dashboard-jvm-micrometer.png](../../images/Installation_Guide/dashboard-jvm-micrometer.png)
### 4.4. Apps 배포
```bash
cd install/apps
./compose.sh up -d
```
혹시 실행 권한이 없다면 다음 구문을 실행
```bash
chmod +x *.sh
./compose.sh up -d
```
### 4.5. Apps 종료
종료를 원하면 다음과 같은 명령어를 실행합니다.
```bash
./compose.sh down
```

### 4.6. Front 배포
```bash
cd install/front
./compose.sh up -d
```
혹시 실행 권한이 없다면 다음 구문을 실행
```bash
chmod +x *.sh
./compose.sh up -d
```
### 4.7. Front 종료
종료를 원하면 다음과 같은 명령어를 실행합니다.
```bash
./compose.sh down
```

## 5. 접속 확인
### 5.1. mago3D 사용자 페이지 접속
* http://dev.localhost/user
* 계정: admin/admin
* 로그인 후, 사용자 페이지 접속
![user-page.png](../../images/Installation_Guide/user-page.png)

### 5.2. mago3D 관리자 페이지 접속
* http://dev.localhost/admin
* 계정: admin/admin
* 로그인 후, 관리자 페이지 접속
![admin-page.png](../../images/Installation_Guide/admin-page.png)
