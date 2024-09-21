# mago3D API 가이드

## 소개(Introduction)

### mago3D란?
mago3D는 2D 및 3D 데이터를 업로드하고, 이를 최적화된 형태로 변환하여 웹 브라우저를 통해 3차원으로 시각화할 수 있는 오픈소스 플랫폼입니다. 다양한 공간 데이터를 손쉽게 관리하고 시각화하는 기능을 제공하여 도시 계획, 시설 관리, 재난 관리 등 여러 분야에서 활용될 수 있습니다.

주요목적은 다음과 같습니다.

* 데이터의 통합 시각화: 2D 및 3D 공간 데이터를 웹 환경에서 통합적으로 시각화하여 복잡한 정보를 직관적으로 이해할 수 있게 합니다.
* 데이터 최적화 및 변환: 사용자가 업로드한 원본 데이터를 웹 환경에서 효율적으로 렌더링할 수 있도록 최적화된 3D 형식으로 변환합니다.

mago3D API는 사용자가 데이터를 업로드, 관리 및 시각화하는 데 필요한 다양한 기능을 제공합니다.  
API는 크게 `세 가지` 어플리케이션으로 구성되어 있으며, 각 어플리케이션은 특정한 기능을 담당합니다:

#### Dataset Application
* 데이터 그룹 관리: 그룹 추가, 수정, 삭제, 목록 조회 및 그룹별 데이터 조회 기능 제공
* 데이터 관리: 2D/3D 데이터 업로드, 데이터 목록 조회, 검색, 수정 및 삭제 기능을 제공
* 데이터 변환: 업로드된 데이터를 웹 환경에서 효과적으로 렌더링할 수 있도록 최적화된 형식으로 변환

#### Layerset Application
* 레이어 그룹 관리: 그룹 추가, 수정, 삭제 및 그룹별 레이어 조회 기능 제공
* 레이어 관리: 레이어 등록, 수정, 삭제 및 레이어 권한(공개/비공개), 켜짐여부(켜짐/꺼짐), 사용여부(사용/미사용) 설정 기능 제공 
* 레이어 미리보기: 변환된 레이어의 미리볼 수 있는 기능 제공
* 레이어 스타일: 벡터 레이어의 점, 선, 면, 속성별 스타일 관리기능 제공

#### Userset Application
* 사용자 관리: 사용자 계정 생성, 수정, 삭제, 조회와 같은 기본적인 사용자 관리 기능 제공
* 권한 관리: 각 사용자 그룹에 대한 접속 권한 설정 기능 제공

### GraphQL API
GraphQL은 Facebook이 개발한 데이터 쿼리 언어로, API를 효율적으로 호출하고 데이터 요청을 최적화하는 데 사용됩니다.  
REST API와 달리, GraphQL에서는 클라이언트가 필요한 데이터의 구조를 명확히 정의할 수 있어 과도한 데이터 전송(over-fetching)이나 부족한 데이터 전송(under-fetching)을 방지할 수 있습니다.  

#### 1. 스키마 (Schema)
* 스키마는 GraphQL 서버의 데이터 구조를 정의하는 역할을 합니다. 스키마는 어떤 데이터가 존재하고, 그 데이터들 간의 관계가 무엇인지, 그리고 클라이언트가 어떤 요청을 할 수 있는지를 명확히 설명합니다.
* 스키마에는 타입(Types), 쿼리(Queries), 뮤테이션(Mutations)이 포함되어 있으며, 이 스키마를 바탕으로 클라이언트는 어떤 데이터를 요청할 수 있는지 알 수 있습니다.

#### 2. 쿼리 (Queries)
* 쿼리는 클라이언트가 데이터를 읽기 위해 서버에 요청을 보내는 방식입니다. 예를 들어, 특정 사용자의 정보를 요청할 때 쿼리를 사용합니다.
* REST에서 GET 요청과 유사하지만, 필요한 데이터 필드만 선택하여 요청할 수 있습니다. 예를 들어, 사용자의 이름과 이메일만 요청할 수 있습니다.
쿼리 예시
```graphql
query {
  asset(id: "1") {
    id
    name
    description
  }
}
```
이 쿼리는 ID가 1인 자산의 ID, 이름, 설명을 요청합니다.

#### 3. 뮤테이션 (Mutations)
* 뮤테이션은 서버의 데이터를 생성(Create), 수정(Update), 삭제(Delete)할 때 사용됩니다. REST의 POST, PUT, DELETE와 비슷한 개념입니다.
* 뮤테이션을 통해 데이터베이스에 변경이 일어난 후, 요청한 클라이언트에게 변경된 데이터가 반환될 수 있습니다.
뮤테이션 예시
```graphql
mutation CreateGroup {
  createGroup(input: { name: "Group 1", description: "Group 1 description" }) {
    id
    name
    description
  }
}
```
이 뮤테이션은 새로운 그룹을 생성하고, 생성된 그룹의 ID, 이름, 설명을 반환합니다.

#### 4. 타입 (Type)
* GraphQL의 모든 데이터는 타입으로 정의됩니다. 타입은 스키마에서 데이터를 어떻게 구성할지 나타내며, 각 타입은 필드를 가지며 필드마다 데이터 유형이 있습니다.
* 예를 들어, User 타입은 사용자의 ID, 이름, 이메일 등의 필드를 가질 수 있습니다.
타입 예시
```graphql
type Asset {
    id: ID!
    name: String!
    description: String
}
```
이 타입 정의는 ID, 이름, 설명 필드를 가지는 Asset 타입을 정의합니다.

#### 5. 필드 (Field)
* GraphQL 쿼리에서 필드는 데이터를 요청하는 단위입니다. 클라이언트는 필요한 필드만 선택적으로 요청할 수 있으며, 서버는 선택된 필드만 반환합니다. 이를 통해 불필요한 데이터를 주고받지 않게 됩니다.

#### 6. 필터링, 페이징, 정렬
* GraphQL은 클라이언트가 쿼리 시 다양한 조건을 걸어 데이터를 필터링하거나 페이징(페이지 단위로 데이터를 나눠서 요청), 정렬 등을 할 수 있는 유연성을 제공합니다.
예시
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
이 쿼리는 assets를 요청하고, 페이지네이션, 정렬, 필드 선택 등을 적용한 예시입니다.

#### GraphQL의 장점
* 효율적인 데이터 전송: 클라이언트는 필요한 데이터만 정확하게 요청할 수 있기 때문에, 불필요한 데이터 전송을 줄일 수 있습니다.
* 하나의 엔드포인트: REST API와 달리 여러 엔드포인트를 사용하지 않고, 하나의 엔드포인트에서 다양한 데이터를 요청할 수 있습니다.
* 타입 시스템: 스키마를 통해 API의 구조가 명확히 정의되어 있어, 요청하는 데이터의 타입을 쉽게 이해할 수 있으며, 개발 중에 오류를 줄일 수 있습니다.

## 시작하기(Getting Started)

* API 엔드포인트: `{{app-server-url}}`: https://dev.localhost/app
  - Dataset Application: `{{app-server-url}}`/api/dataset/graphql
  - Layerset Application: `{{app-server-url}}`/api/layerset/graphql
  - Userset Application: `{{app-server-url}}`/api/userset/graphql

* 인증 방법: API 사용 시 필요한 인증 방식은 JWT 토큰 방식 입니다, 예제 요청은 다음과 같습니다:
  `{{auth-server-url}}`/realms/`{{auth-realm}}`/protocol/openid-connect/token
  `{{auth-server-url}}`: https://dev.localhost/auth
  `{{auth-realm}}`: mago3d 

POST https://dev.localhost/auth/realms/mago3d/protocol/openid-connect/token

#### 1. mago3d-front 클라이언트
```json
{
  "grant_type": "password",
  "client_id": "mago3d-front",
  "username": "admin",
  "password": {{admin password}}
}
```

#### 2. mago3d-api 클라이언트
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

* 요청 및 응답 형식: GraphQL 쿼리 및 뮤테이션의 요청 형식과 서버로부터 받는 응답 형식에 대해 설명합니다.

#### 쿼리 요청 예시
```graphql
query Asset {
  asset(id: "1") {
    id
    name
    description
  }
}
```
#### 쿼리 응답 예시
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
#### 뮤테이션 요청 예시
```graphql
mutation CreateGroup {
  createGroup(input: { name: "Group 1", description: "Group 1 description" }) {
    id
    name
    description
  }
}
```

#### 뮤테이션 응답 예시
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

#### 에러처리 응답
GraphQL 요청이 실패하면, errors 필드를 포함한 응답이 반환됩니다.
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

## 스키마 개요 (Schema Overview)

* 타입 (Types)
* 쿼리 (Queries)
* 뮤테이션 (Mutations)

[mago3D API 문서](https://mdtp.gaia3d.com/doc/) 참고

## 예제 (Examples)

데이터 변환
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

데이터 변환 상태 조회
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

레이어 발행
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

레이어 목록 조회
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