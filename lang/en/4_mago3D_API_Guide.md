# mago3D API Guide

## Introduction

### What is mago3D?
mago3D is an open-source platform that can upload 2D and 3D data, convert them into optimized forms, and visualize them in three dimensions through a web browser. It provides the ability to easily manage and visualize various spatial data, which can be used in many fields such as urban planning, facility management, and disaster management.

The main purposes are:

* Integrated visualization of data: Integrated visualization of 2D and 3D spatial data in the web environment enables intuitive understanding of complex information.
* Data Optimization and Transformation: Transforms user-uploaded original data into a 3D format optimized for efficient rendering in a web environment.

The mago3D API provides a variety of features users need to upload, manage, and visualize data.  
The API is largely composed of `three` applications, each of which is responsible for a specific function:

#### Dataset Application
* Data Group Management: Add, modify, delete, list query, and group-specific data query capabilities
* Data Management: Provides 2D/3D data upload, data list lookup, search, modification, and deletion capabilities
* Data conversion: transforming uploaded data into an optimized format for effective rendering in a web environment

#### Layerset Application
* Layer Group Management: Provides addition, modification, deletion, and layer lookup by group
* Layer Management: Provides layer registration, modification, deletion, and layer permission (open/private), on/off, and on/off settings
* Layer Preview: Provides the ability to preview transformed layers
* Layer Style: Provides style management by point, line, plane, and attribute of vector layer

#### Userset Application
* User Management: Provides basic user management functions such as creating, modifying, deleting, and querying user accounts
* Administering permissions: Provides access permissions settings for each user group

### GraphQL API
GraphQL is a Facebook-developed data query language used to efficiently call APIs and optimize data requests.  
Unlike REST APIs, GraphQL allows clients to clearly define the structure of the data they need, preventing over-fetching or under-fetching.

#### 1. Schema
* The schema defines the data structure of a GraphQL server. The schema clarifies what data exists, what relationships are between them, and what requests clients can make.
* The schema includes Types, Queries, and Mutation, which allows clients to know what data they can request.

#### 2. Queries
* A query is the way a client sends a request to a server to read data; for example, it uses a query to request information from a particular user.
* It is similar to the GET request in REST, but you can only select and request the required data fields; for example, you can only request the user's name and email.
  Query Example
```graphql
query {
  asset(id: "1") {
    id
    name
    description
  }
}
```
This query asks for the ID, name, and description of an asset with ID 1.

#### 3. Mutations
* Mutation is used to create, update, and delete data on a server. It is similar to REST's POST, PUT, and DELETE concepts.
* After changes to the database occur through mutation, the changed data may be returned to the requested client.
  Mutation Example
```graphql
mutation CreateGroup {
  createGroup(input: { name: "Group 1", description: "Group 1 description" }) {
    id
    name
    description
  }
}
```
This mutation creates a new group and returns the ID, name, and description of the created group.

#### 4. Type
* All data in GraphQL is defined as a type. Types indicate how you want to configure data in the schema, each type has a field, and each field has a data type.
* For example, the User type may have fields such as the user's ID, name, and email.
  Type Example
```graphql
type Asset {
    id: ID!
    name: String!
    description: String
}
```
This type definition defines an asset type with ID, name, and description fields.

#### 5. Field
In a GraphQL query, a field is a unit of data request. Clients can only selectively request the required fields, and the server returns only the selected fields. This eliminates the need for unnecessary data.

#### 6. Filtering, paging, sorting
* GraphQL gives clients the flexibility to filter data, paging (requested page-by-page), sorting, and so on with a variety of criteria when querying. 
example
```graphql
query Assets {
  assets(pageable: { page: 0, size: 10, sort: [CREATED_AT_DESC] }) {
    items {
      id
      name
      description
    }
  }
}
```
This query is an example of requesting assets, applying pagenation, sorting, field selection, etc.

#### Benefits of GraphQL
* Efficient data transfer: Clients can only request the data they need accurately, reducing unnecessary data transfer.
* One endpoint: Unlike REST APIs, a single endpoint can request a variety of data without the use of multiple endpoints.
* Type System: The structure of the API is clearly defined through the schema, making it easy to understand the type of data requested and reducing errors during development.

## Getting Started

* API endpoints: `{{app-server-url}}`: https://dev.localhost/app
  - Dataset Application: `{{app-server-url}}`/api/dataset/graphql
  - Layerset Application: `{{app-server-url}}`/api/layerset/graphql
  - Userset Application: `{{app-server-url}}`/api/userset/graphql

* Authentication Method: The authentication method required when using API is the JWT token method, the example request is as follows:
  `{{auth-server-url}}`/realms/`{{auth-realm}}`/protocol/openid-connect/token  
  `{{auth-server-url}}`: https://dev.localhost/auth  
  `{{auth-realm}}`: mago3d  
  POST https://dev.localhost/auth/realms/mago3d/protocol/openid-connect/token

#### 1. mago3d-front client
```json
{
  "grant_type": "password",
  "client_id": "mago3d-front",
  "username": "admin",
  "password": {{admin password}}
}
```

#### 2. mago3d-api client
```json
{
  "grant_type": "client_credentials",
  "client_id": "mago3d-api",
  "client_secret": {{client secret key}}
}
```

```json
{
    "access_token": {{access token}},
    "expires_in": 35999,
    "refresh_expires_in": 0,
    "token_type": "Bearer",
    "not-before-policy": 0,
    "scope": "profile email"
}
```

* Request and Response Format: Describes the request formats for GraphQL queries and mutations and the response formats received from the server.

#### Example of query request
```graphql
query Asset {
  asset(id: "1") {
    id
    name
    description
  }
}
```
#### Example of query response
```json
{
  "data": {
    "asset": {
      "id": "1",
      "name": "Asset 1",
      "description": "This is asset 1"
    }
  }
}
```
#### Example of mutation request
```graphql
mutation CreateGroup {
  createGroup(input: { name: "Group 1", description: "Group 1 description" }) {
    id
    name
    description
  }
}
```

#### Example of mutation response
```json
{
  "data": {
    "createGroup": {
      "id": "1",
      "name": "Group 1",
      "description": "Group 1 description"
    }
  }
}
```

#### Error Handling Response
If the GraphQL request fails, a response containing the errors field is returned.
```json
{
  "errors": [
    {
      "message": "AssetNotFound",
      "locations": [
        {
          "line": 2,
          "column": 5
        }
      ],
      "path": [
        "asset"
      ],
      "extensions": {
        "classification": "NOT_FOUND"
      }
    }
  ],
  "data": {
    "asset": null
  }
}
```

## Schema Overview)

* Types
* Queries
* Mutations

Refer [mago3D API document](https://mdtp.gaia3d.com/doc/)

## Examples

Data Conversion
```graphql
mutation CreateProcess {
    createProcess(
        input: {
            name: "convert 1"
            source: { assetId: [1] }
            context: { t3d: { inputType: FBX, recursive: true } }
        }
    ) {
        id
        name
        status
        createdBy
        createdAt
        updatedBy
        updatedAt
    }
}
```

Get data conversion status
```graphql
query Process {
    process(id: "1") {
        id
        name
        context
        status
    }
}
```

Publish Layer
```graphql
mutation CreateAsset {
    createAsset(
        input: {
            name: "test"
            description: "test"
            context: { t3d: { dataAssetId: "1" } }
            type: TILES3D
        }
    ) {
        id
        name
        description
        type
        enabled
        visible
        access
        status
        order
    }
}
```

Get Layer list
```graphql
query Assets {
  assets {
    id
    name
    description
    type
    enabled
    visible
    access
    status
    order
    properties
  }
}
```