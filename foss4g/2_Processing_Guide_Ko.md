# mago3D 데이터 가공 가이드

# 사용할 데이터 추출

## 1. Overture Maps

- 파이썬 가상 환경에서 받은 GeoJSON 데이터의 전처리가 필요합니다.
- 가상환경을 설정했던 C:\mago3d 경로에 받아진 GeoJSON 파일을 모두 C:\mago3d\workspace 파일로 옮겨줍니다.

### 1. khlongtoei_building.geojson

- mago3d-tiler를 돌려 tileset.json 파일로 변환할 파일입니다.
- 해당 GeoJSON 파일에는 높이 값이 없는 건물들이 포함되어 있으므로 건물의 높이 값을 추출하여 가공합니다.
- khlongtoei_building.geojson 파일을 복사하여 khlongtoei_building_origin.geojson 파일을 만들어줍니다.
- khlongtoei_building_origin.geojson 파일에서 건물 높이를 추출합니다.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_hegiht.geojson /data/khlongtoei_building_origin.geojson -sql "SELECT height FROM khlongtoei_building_origin WHERE height IS NOT NULL"
    ```
- khlongtoei_building_origin.geojson 파일에서 건물 층수를 높이 값으로 변환합니다.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_num_floors.geojson /data/khlongtoei_building_origin.geojson -sql "SELECT num_floors * 3.3 AS height FROM khlongtoei_building_origin WHERE height IS NULL"
    ```
- 추출한 건물 높이와 건물 층수 높이를 khlongtoei_building.geojson 파일에 병합합니다.
    ```sql 
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_building.geojson /data/khlongtoei_hegiht.geojson
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" -append /data/khlongtoei_building.geojson /data/khlongtoei_num_floors.geojson
    ```
- C:\mago3d\workspace 경로에 input 폴더를 생성하여 병합이 완료된 khlongtoei_building.geojson 파일을 넣어줍니다.

### 2. khlongtoei_transportation.geojson

- geosever에 레이어로 올리기 위해 Geopackage 파일로 변환할 파일입니다.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GPKG" /data/rome_segments.gpkg /data/khlongtoei_transportation.geojson
    ```
- C:\mago3d\workspace\geoserver 경로에 data 폴더를 생성하여 변환해준 gpkg 파일을 넣어줍니다.

---

## 2. Copernicus Data Space Ecosystem

- geoserver에 레이어로 올리기 위해 GeoTIff 파일로 변환할 파일입니다.
- 다운로드 경로에 받아진 SAFE.zip 파일의 압축을 해제 해줍니다.
- GRANULE\L2A_T47PPR_A046247_20240430T034959\IMG_DATA\R10m 경로에 있는 T47PPR_20240430T033541_TCI_10m.jp2 파일을 C:\mago3d\workspace 폴더로 옮겨줍니다.
- jp2 파일을 tif 파일로 변환합니다.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 gdal_translate -of GTiff /data/T47PPR_20240430T033541_TCI_10m.jp2 /data/T47PPR_20240430T033541_TCI_10m.tif
    ```
- C:\mago3d\workspace\geoserver\data 경로에 변환해준 tif 파일을 넣어줍니다.

---

## 3. NASA DEM

- mago3d-terrainer를 통해 terrain 정보로 변환할 파일이며, mago3d-tiler를 실행할 때도 사용됩니다.
- 다운로드 경로에 받아진 ASTGTM_003-20241118_054943 폴더를 열어 ASTGTMV003_N13E100_dem.tif 파일을 복사해줍니다.
- C:\mago3d\workspace\input 경로에 복사해준 파일을 붙여넣습니다.
- C:\mago3d\workspace 경로에 dem 폴더를 생성하여 복사해준 파일을 붙여넣습니다.

---

# MAGO3D 사용하기

- C:\mago3d\workspace 경로의 input과 dem의 폴더 안에 데이터가 잘 들어가있는지 확인합니다.
    - input> khlongtoei_building.geojson, ASTGTMV003_N13E100_dem.tif
    - dem> ASTGTMV003_N13E100_dem.tif
  
## MAGO3D-TILER

- 건물의 기본 높이 정보를 3.3m로 지정하여 mago3d-tiler를 돌립니다.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/workspace gaia3d/mago-3d-tiler -input /workspace/input -output /workspace/output -it geojson -crs 4326 -te /workspace/dem/ASTGTMV003_N13E100_dem.tif -mh 3.3 -hc height
    ```

## MAGO3D-TERRAINER

- terrain의 level을 14로 지정하여 mago3d-terrainer를 돌립니다.
    ```sql
    $ docker run --rm -v C:\gaia3d\workspace:/workspace gaia3d/mago-3d-terrainer -input /workspace/dem -output /workspace/assets/terrain -cn -it bilinear -mn 0 -mx 14
    ```

---

# Geosever 사용하기

## 1. geoserver 접속하기

- chrome 주소창에 geoserver를 설치할 때 지정해준 포트로 접속합니다.
    ```sql
    http://localhost:8080/geoserver
    ```
- 화면 상단에서 설치할 때 지정해준 id와 password로 로그인합니다.
    ```sql
     admin / geoserver
    ```
## 2.

---

# Sample code를 사용하여 Web에서 확인하기

- 원하는 IDE로 C:\mago3d\workspace\index.html 파일을 열어줍니다.
- ✏️ 아이콘이 있는 코드들을 사용자 환경에 맞게 수정합니다.
- index.html 파일을 켜둔 상태로 서버를 활성화 시켜 chrome에서 결과물을 확인합니다.

## IDE

### 1. Intellij
  ![](images/en/intellijServer.png)

### 2. VsCode
  ![](images/en/vsCodeLiveExtension.png)
  ![](images/en/vsCodeServer.png)

