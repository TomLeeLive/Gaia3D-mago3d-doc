# Mago3D Data Collection Guide

## :bookmark_tabs: Data Construction Approach

## ⚙️ Basic Setup

### 1. Create Practice Folder in Desired Path

Create a folder to be used for the practice.  
This folder will serve as the basic workspace for storing and managing data throughout the practice.  
Follow the steps below according to your Windows or Mac/Linux environment.

### Windows

> 1. Open Command Prompt
>   - Search for and launch cmd or Command Prompt from the start menu.
> 2. Enter the following command to create the folder:
>    ```sql
>    C:\> mkdir mago3d
>    ```
> 3. The created folder will be located at C:\mago3d path.

### Mac / Linux

> 1. Launch Terminal
>    - On Mac, launch from Launchpad, on Linux from the applications menu.
> 2. Enter the following command to create the folder:
>    ```sql
>    $ mkdir ~/mago3d
>    ```
> 3. The created folder will be located in the home directory (~/mago3d).

Practice preparation is now complete. Proceed to the next step! 🚀

---

### 2. Using Docker

Download the Docker images required for the practice and set up the practice environment by running containers.
Follow the steps below carefully.

#### 1. Download Docker Images

Pre-download the images needed for the practice. Enter the following commands to pull the images locally.

```sql
docker pull gaia3d/mago-3d-tiler
docker pull gaia3d/mago-3d-terrainer
docker pull kartoza/geoserver
docker pull ghcr.io/osgeo/gdal:ubuntu-full-3.9.0
```

---

#### Image Description

> - `gaia3d/mago-3d-tiler`: Image used for 3D tiling work in mago3d
> - `gaia3d/mago-3d-terrainer`: Image for terrain data processing
> - `kartoza/geoserver`: Image for managing and visualizing spatial data through GeoServer
> - `ghcr.io/osgeo/gdal`: Image providing spatial data processing capabilities with the GDAL library

---

#### ⚠️ If You Encounter Permission Issues with GeoServer on Mac

> 1. Delete the existing directory and create a new GeoServer directory.
> 2. Run the command `chmod 777 {workspace}/geoserver` to change the permissions of the GeoServer directory.
> 3. Run the Docker image again.

---

#### 2. Run Docker Containers

Run containers based on the downloaded images.  
Enter the following command to run the GeoServer container.

### Windows

```sh
docker run ^
  -v C:\mago3d\geoserver:/apt/geoserver/data_dir ^
  -e GEOSERVER_ADMIN_USER=admin ^
  -e GEOSERVER_ADMIN_PASSWORD=geoserver ^
  -p 8080:8080 kartoza/geoserver
```

### Mac / Linux
```sh
docker run \
  -v C:/mago3d/geoserver:/apt/geoserver/data_dir \
  -e GEOSERVER_ADMIN_USER=admin \
  -e GEOSERVER_ADMIN_PASSWORD=geoserver \
  -p 8080:8080 kartoza/geoserver
```

---

#### Command Explanation

> - `-v`: Data directory volume mount
>   - Mount the `C:\mago3d\geoserver` path to GeoServer's data_dir to store data.
> - `-e`: Environment variable setting
>   - GEOSERVER_ADMIN_USER: Admin account name (admin)
>   - GEOSERVER_ADMIN_PASSWORD: Admin account password (geoserver)
> - `-p`: Port forwarding
>   - 8080:8080: Connect host and container's 8080 ports.

---

### 3. Verify GeoServer Access

After running the container, access the GeoServer admin screen via http://localhost:8080 in your web browser.

> - Admin account information:
>   - Username: admin
>   - Password: geoserver

---

### 4. IDE Setup

An IDE (Integrated Development Environment) is a tool that helps programmers write and manage code more efficiently.  
In the final chapter of this practice, you’ll use an IDE to see the results of your work.  
We recommend using Visual Studio Code or IntelliJ.  

If you haven’t installed one yet, you can download Visual Studio Code for free from https://code.visualstudio.com/.

---

The Docker-based practice environment is now ready! Proceed to the next step. 🎉

---

In this practice, we will download data for urban digital twin construction, including building, transportation, satellite imagery, and DEM (Digital Elevation Model) data.  
These data are available from platforms like Overture Maps, NASA, and Copernicus Data Space Ecosystem, all accessible as **Open Data**.

These data serve as fundamental and important resources for representing and analyzing urban spatial information three-dimensionally, utilizing various data formats such as 3D, Vector, Raster, and Terrain.


## :globe_with_meridians: Downloading Overture Maps Data

### 1. Verify Python Installation

- [Install Python](https://www.python.org/downloads/)
- Open cmd and check if Python is installed. Enter the following command:

    ```sh
    python --version
    ```

### 2. Create Virtual Environment

- Navigate to the directory where you want to create the virtual environment. To move to the directory we created earlier, enter:

    ```sh
    cd C:\mago3d
    ```

- Enter the following command to create a virtual environment:

    ```sh
    python -m venv myvenv
    ```

- 'myvenv' is the name of the virtual environment. You can change it to your preferred name.

### 3. Activate Virtual Environment

- To activate the virtual environment, enter the following command in the cmd:

    ```sh
    $ myvenv\Scripts\activate
    ```

    ```sh
    # linux/mac
    source myenv/bin/activate
    ```

- After executing this command, the prompt will change to '(myvenv)', indicating the virtual environment is activated.

### 4. Install Overture Maps Package

- With the virtual environment activated, enter the following command to install the Overture Maps package:

    ```sh
    pip install overturemaps
    ```

### 5. Download Overture Maps Data

- With the virtual environment activated, enter the following commands to download Overture Maps data:
- Download Bangkok's Building data as khlongtoei_building.geojson:
 
    ```sh
    overturemaps download \
        --bbox=100.5507001257371797,13.6970007530963525,100.6016431134770528,13.7428667529314463 \
        -f geojson \
        --type=building \
        -o khlongtoei_building.geojson
    ```

- Download Bangkok's transportation data as khlongtoei_transportation.geojson:

    ```sh
    overturemaps download \
        --bbox=100.5507001257371797,13.6970007530963525,100.6016431134770528,13.7428667529314463 \
        -f geojson \
        --type=segment \
        -o khlongtoei_transportation.geojson
    ```

- The downloaded files will be saved in the directory where you created the virtual environment (C:\mago3d).

## :telescope: Downloading Sentinel Images

### 1. Access Copernicus Data Space Ecosystem

- Login is required.

[Copernicus Data Space Ecosystem | Europe's eyes on Earth](https://dataspace.copernicus.eu/)

### 2. Set Data Search Conditions

- Move to the desired area, zoom in, click the search button, select SENTINEL-2 > MSI > L2A, and adjust cloud cover to 5%.

### 3. Download Data

- The list of searched images and their coverage will appear on the screen.
- Once you've found the desired image, click to download.



## :rocket: Download NASA DEM

### 1. Access NASA EARTHDATA

- Login is required.
- You must install the Earthdata Download app to download .tif files.

[search.earthdata.nasa.gov](https://search.earthdata.nasa.gov/search/granules?p=C1711961296-LPCLOUD&pg[0][v]=f&pg[0][gsk]=-start_date&as[science_keywords][0]=Land%20Surface%3ATopography%3ATerrain%20Elevation%3ADigital%20Elevation/Terrain%20Model%20(Dem)&tl=1723601365!3!!&fst0=Land%20Surface&fsm0=Topography&fs10=Terrain%20Elevation&fs20=Digital%20Elevation/Terrain%20Model%20(Dem))

### 2. Specify Area

- Use the tools on the right to specify the area you want to download.

### 3. DEM Download Data

- Download the data corresponding to the specified area.
