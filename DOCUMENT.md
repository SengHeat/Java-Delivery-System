# Personal Access Token (PAT) Implementation Guide
## Step-by-Step Tasks (No Code - Documentation Only)

---

## PHASE 1: Domain Models & Events (Weeks 1-2)

### Task 1.1: Create Value Objects
**Objective:** Create immutable value objects for token identification and naming

**Files to Create:**
- `domain/personalAccessToken/model/TokenId.java`
- `domain/personalAccessToken/model/TokenName.java`
- `domain/personalAccessToken/model/PermissionId.java`

**Requirements:**
- TokenId: Wrap UUID value, provide generate() factory method, implement equals/hashCode
- TokenName: Validate non-empty, max 100 characters, immutable after creation
- PermissionId: Wrap UUID value similar to TokenId

**Testing:**
- Unit tests for value object validation
- Test immutability
- Test equality comparison

---

### Task 1.2: Create Enums
**Objective:** Define possible states for tokens and their descriptions

**Files to Create:**
- `domain/personalAccessToken/model/TokenStatus.java`

**Requirements:**
- ACTIVE: Token is usable
- REVOKED: Token has been manually revoked
- EXPIRED: Token has passed expiration date
- Include description for each status

**Testing:**
- Enum constant visibility tests
- Description retrieval tests

---

### Task 1.3: Create Entity Classes
**Objective:** Build TokenPermission entity for managing individual permissions

**Files to Create:**
- `domain/personalAccessToken/model/TokenPermission.java`

**Requirements:**
- Store permission code (e.g., "order:read", "delivery:write")
- Store permission description
- Store grantedAt timestamp
- Validate permission code is not empty
- Implement equals/hashCode based on code

**Testing:**
- Test permission creation
- Test code validation
- Test equals logic for permission matching

---

### Task 1.4: Create Aggregate Root
**Objective:** Build PersonalAccessToken aggregate root with business logic

**Files to Create:**
- `domain/personalAccessToken/model/PersonalAccessToken.java`

**Requirements:**
- Private constructor, static create() factory method
- Store token hash (not plain token), userId, tokenName, permissions list, status, timestamps
- Implement isExpired() - check if LocalDateTime.now() > expiresAt
- Implement isIpAllowed() - check if ipAddress is in whitelist (or allow all if empty)
- Implement hasPermission() - check if specific permission exists
- Implement hasAllPermissions() - check if all required permissions exist
- Implement recordUsage() - update lastUsedAt, validate active/not-expired/ip-allowed
- Implement revoke() - change status to REVOKED, set revokedAt/revokeReason
- Create collection for domain events, implement getDomainEvents()
- Validate all inputs in factory method

**Business Rules to Enforce:**
- Cannot revoke already-revoked token
- Cannot use expired token
- Cannot use non-active token
- Cannot use token from disallowed IP
- Expiration date must be in future
- At least one permission required

**Testing:**
- Test token creation with valid inputs
- Test rejection of invalid inputs
- Test status transitions
- Test permission checking logic
- Test IP whitelist logic
- Test usage recording

---

### Task 1.5: Create Domain Events
**Objective:** Define events for token lifecycle tracking

**Files to Create:**
- `domain/personalAccessToken/event/DomainEvent.java` (base class)
- `domain/personalAccessToken/event/PersonalAccessTokenCreatedEvent.java`
- `domain/personalAccessToken/event/PersonalAccessTokenRevokedEvent.java`
- `domain/personalAccessToken/event/PersonalAccessTokenUsedEvent.java`

**Requirements:**
- DomainEvent: Abstract base with occurredAt timestamp, abstract getId() method
- CreatedEvent: Include tokenId, userId, tokenName, permissions list
- RevokedEvent: Include tokenId, userId, reason
- UsedEvent: Include tokenId, userId, ipAddress, usedAt timestamp

**Testing:**
- Test event instantiation
- Test event data retrieval
- Test timestamp generation

---

### Task 1.6: Create Domain Repository Interface
**Objective:** Define repository contract for token persistence

**Files to Create:**
- `domain/personalAccessToken/repository/PersonalAccessTokenRepository.java`

**Required Methods:**
- void save(PersonalAccessToken token)
- Optional<PersonalAccessToken> findById(TokenId tokenId)
- Optional<PersonalAccessToken> findByTokenHash(String tokenHash)
- List<PersonalAccessToken> findByUserId(String userId)
- List<PersonalAccessToken> findByUserIdAndStatus(String userId, TokenStatus status)
- List<PersonalAccessToken> findExpiredTokens()
- void delete(TokenId tokenId)

**Implementation Notes:**
- This is interface only - implementation comes in infrastructure layer
- Use domain objects, not JPA entities

---

### Task 1.7: Create Domain Service
**Objective:** Implement business logic for token operations

**Files to Create:**
- `domain/personalAccessToken/service/PersonalAccessTokenDomainService.java`

**Required Methods:**
- createToken(userId, tokenName, permissionCodes, expirationDays) → PersonalAccessToken
- revokeToken(tokenId, reason) → void
- validateAndUseToken(plainToken, ipAddress) → userId
- getUserActiveTokens(userId) → List<PersonalAccessToken>
- cleanupExpiredTokens() → void (scheduled)

**Business Logic:**
- Validate user exists before creating token
- Validate expirationDays: 1-365 range
- Convert expirationDays to LocalDateTime
- Hash token for storage
- Publish domain events after operations
- Auto-revoke expired tokens during cleanup

**Testing:**
- Test token creation with valid inputs
- Test rejection of invalid inputs
- Test token validation
- Test event publishing
- Test cleanup job

---

## PHASE 2: Infrastructure & Persistence (Weeks 3-4)

### Task 2.1: Create JPA Entities
**Objective:** Map domain models to database tables

**Files to Create:**
- `infrastructure/persistence/entity/PersonalAccessTokenEntity.java`
- `infrastructure/persistence/entity/TokenPermissionEntity.java`
- `infrastructure/persistence/entity/TokenUsageLogEntity.java`

**Requirements for PersonalAccessTokenEntity:**
- @Entity @Table with name "personal_access_tokens"
- UUID tokenId as @Id
- UUID userId field
- String tokenName, tokenHash, status, revokeReason
- LocalDateTime: createdAt, expiresAt, lastUsedAt, revokedAt, updatedAt
- String ipWhitelist
- @ElementCollection for permissions
- @Index annotations on userId, tokenHash, status, expiresAt

**Requirements for TokenPermissionEntity:**
- @Embeddable class
- String code, description
- LocalDateTime grantedAt

**Requirements for TokenUsageLogEntity:**
- UUID usageId as @Id
- UUID tokenId, userId (both @Column, @ForeignKey references)
- String ipAddress, endpoint, httpMethod
- Integer statusCode
- LocalDateTime usedAt
- @Index on tokenId, userId, usedAt

**Testing:**
- Test entity creation
- Test JPA annotations
- Test index configuration

---

### Task 2.2: Create JPA Repositories
**Objective:** Implement database queries

**Files to Create:**
- `infrastructure/persistence/repository/jpa/PersonalAccessTokenJpaRepository.java`
- `infrastructure/persistence/repository/jpa/TokenUsageLogJpaRepository.java`

**PersonalAccessTokenJpaRepository Methods:**
- extends JpaRepository<PersonalAccessTokenEntity, UUID>
- Optional<PersonalAccessTokenEntity> findByTokenHash(String tokenHash)
- List<PersonalAccessTokenEntity> findByUserId(UUID userId)
- List<PersonalAccessTokenEntity> findByUserIdAndStatus(UUID userId, String status)
- @Query method: findExpiredTokens(LocalDateTime now) - use WHERE expiresAt < :now AND status = 'ACTIVE'
- @Query method: countActiveTokensByUser(UUID userId)

**TokenUsageLogJpaRepository Methods:**
- extends JpaRepository<TokenUsageLogEntity, UUID>
- List<TokenUsageLogEntity> findByTokenId(UUID tokenId)
- Page<TokenUsageLogEntity> findByTokenId(UUID tokenId, Pageable pageable)
- @Query: findByTokenIdAndRecentUsage(UUID tokenId, LocalDateTime since)

**Testing:**
- Test CRUD operations
- Test custom query methods
- Test native query execution

---

### Task 2.3: Create Mappers
**Objective:** Convert between domain and JPA entities

**Files to Create:**
- `infrastructure/persistence/mapper/PersonalAccessTokenMapper.java`

**Requirements:**
- @Mapper(componentModel = "spring")
- PersonalAccessToken toDomain(PersonalAccessTokenEntity entity)
- PersonalAccessTokenEntity toEntity(PersonalAccessToken domain)
- List<PersonalAccessToken> toDomainList(List<PersonalAccessTokenEntity> entities)
- Handle TokenPermissionEntity ↔ TokenPermission conversion
- Deep copy collections to prevent external modification

**Testing:**
- Test entity → domain conversion
- Test domain → entity conversion
- Test collection mapping
- Test null handling

---

### Task 2.4: Create Repository Implementation
**Objective:** Implement domain repository interface

**Files to Create:**
- `infrastructure/persistence/repository/PersonalAccessTokenRepositoryImpl.java`

**Implementation Strategy:**
- @Repository annotation
- Inject PersonalAccessTokenJpaRepository and PersonalAccessTokenMapper
- Implement all methods from PersonalAccessTokenRepository interface
- Use mapper to convert between entity and domain
- Handle Optional properly
- Stream/collect for List conversions

**Testing:**
- Test all repository methods
- Test mapper integration
- Test transaction handling

---

### Task 2.5: Create Database Migrations
**Objective:** Set up database schema

**Files to Create:**
- `db/migration/V001__Create_PersonalAccessToken_Tables.sql`

**Schema Requirements:**
- personal_access_tokens table with all fields
- token_permissions table (linked via token_id)
- token_usage_logs table
- Proper indexes on search columns
- Foreign key constraints
- Check constraints for business rules
- Timestamps with defaults

**Testing:**
- Test schema creation
- Test data insertion
- Test index creation
- Test foreign key constraints

---

## PHASE 3: Application Services (Weeks 5-6)

### Task 3.1: Create Commands & Queries
**Objective:** Define input/output for application operations

**Files to Create:**
- `application/personalAccessToken/command/CreatePersonalAccessTokenCommand.java`
- `application/personalAccessToken/command/RevokePersonalAccessTokenCommand.java`
- `application/personalAccessToken/query/GetPersonalAccessTokensQuery.java`

**Command Requirements:**
- CreatePersonalAccessTokenCommand: userId, tokenName, permissions (List<String>), expirationDays
- RevokePersonalAccessTokenCommand: tokenId, reason
- Use @Data, @Builder for fluent API
- Include validation annotations (@NotNull, @NotEmpty, @Min, @Max)

**Query Requirements:**
- GetPersonalAccessTokensQuery: userId, optional filter/pagination parameters
- Should be immutable

**Testing:**
- Test command creation with valid inputs
- Test validation annotations
- Test builder pattern

---

### Task 3.2: Create DTOs
**Objective:** Define API request/response models

**Files to Create:**
- `application/personalAccessToken/dto/CreateTokenRequest.java`
- `application/personalAccessToken/dto/CreateTokenResponse.java`
- `application/personalAccessToken/dto/PersonalAccessTokenDto.java`
- `application/personalAccessToken/dto/RevokeTokenRequest.java`

**CreateTokenRequest:**
- tokenName (String, required, 3-100 chars)
- permissions (List<String>, required, non-empty)
- expirationDays (Integer, required, 1-365)

**CreateTokenResponse:**
- tokenId (UUID)
- tokenName (String)
- token (String - only returned once!)
- expiresAt (LocalDateTime)
- permissions (List<String>)
- warning (String - remind user to save token)

**PersonalAccessTokenDto:**
- tokenId, tokenName, status, createdAt, expiresAt, lastUsedAt
- permissions (List<String>)
- maskedToken (e.g., "delivery_pat_****...****")
- isExpired (Boolean)

**RevokeTokenRequest:**
- reason (String, required, 10-500 chars)

**Testing:**
- Test DTO instantiation
- Test validation
- Test serialization/deserialization

---

### Task 3.3: Create Application Services (CQRS Pattern)
**Objective:** Implement business operations

**Files to Create:**
- `application/personalAccessToken/service/CreatePersonalAccessTokenApplicationService.java`
- `application/personalAccessToken/service/RevokePersonalAccessTokenApplicationService.java`
- `application/personalAccessToken/service/GetPersonalAccessTokensQueryService.java`

**CreateApplicationService:**
- handle(CreatePersonalAccessTokenCommand) → CreateTokenResponse
- Call domain service to create token
- Generate plain token string (format: delivery_pat_<uuid>)
- Return response with plain token (logged and shown to user once)
- Publish domain events
- Transaction: @Transactional

**RevokeApplicationService:**
- handle(RevokePersonalAccessTokenCommand) → void
- Call domain service to revoke
- Publish events
- Transaction: @Transactional

**QueryService:**
- handle(GetPersonalAccessTokensQuery) → List<PersonalAccessTokenDto>
- Query repository by userId
- Map to DTOs (mask tokens)
- Transaction: @Transactional(readOnly = true)

**Testing:**
- Test command handling
- Test event publishing
- Test response generation
- Test query execution

---

### Task 3.4: Create Token Security Service
**Objective:** Implement security-related operations

**Files to Create:**
- `domain/personalAccessToken/service/TokenSecurityService.java`

**Required Methods:**
- analyzeSuspiciousActivity(tokenId) - detect rapid requests, multiple IPs, etc.
- validateTokenPermissions(permissions) - check for overly broad permissions
- generateSecureToken() - create random token string
- hashToken(plainToken) - BCrypt with 12 rounds
- validateTokenStrength() - check permission granularity

**Business Logic:**
- Flag if >100 requests/hour from single token
- Flag if 5+ unique IPs in 1 hour
- Warn on dangerous permissions (admin:*, *)
- Auto-revoke suspicious tokens

**Testing:**
- Test suspicious activity detection
- Test token generation randomness
- Test hashing consistency
- Test permission validation

---

## PHASE 4: Security & Authentication (Weeks 7-8)

### Task 4.1: Create Authentication Filter
**Objective:** Intercept requests and validate PAT tokens

**Files to Create:**
- `infrastructure/security/PersonalAccessTokenAuthenticationFilter.java`

**Requirements:**
- Extend OncePerRequestFilter
- Extract token from Authorization header (Bearer scheme)
- Validate token format: "delivery_pat_<uuid>"
- Look up token in repository by hash
- Check token status (ACTIVE)
- Check token not expired
- Check IP whitelist
- Create UsernamePasswordAuthenticationToken with user authorities
- Set in SecurityContext
- Handle exceptions gracefully

**Flow:**
1. Extract Authorization header
2. Verify Bearer prefix
3. Extract token substring
4. Hash token
5. Query repository
6. Validate status/expiration/IP
7. Build authentication with permissions as GrantedAuthority
8. Set in SecurityContext
9. Continue filter chain

**Testing:**
- Test valid token authentication
- Test invalid token rejection
- Test expired token rejection
- Test IP whitelist enforcement
- Test header parsing

---

### Task 4.2: Create Permission Constants
**Objective:** Define all available permissions

**Files to Create:**
- `infrastructure/security/TokenPermissionConstants.java`

**Permission Categories:**
- Order: order:read, order:create, order:update, order:delete
- Delivery: delivery:read, delivery:update, delivery:track
- Driver: driver:read, driver:update, driver:manage
- Customer: customer:read, customer:update
- Payment: payment:read, payment:process, payment:refund
- Notification: notification:read, notification:send
- Admin: admin:read, admin:write, admin:delete

**Requirements:**
- Define as public static final String constants
- Create getAllPermissions() method returning List
- Create getPermissionsByCategory() helper method

**Testing:**
- Test constant values
- Test list generation
- Test no duplicates

---

### Task 4.3: Update Security Configuration
**Objective:** Integrate PAT into security chain

**Files to Create:**
- `infrastructure/config/SecurityConfigWithPAT.java` (update existing)

**Requirements:**
- Keep existing JWT filter
- Add PAT filter BEFORE JWT filter in chain
- PAT filter attempts first, JWT filter if PAT fails
- Configure AnonymousAuthenticationFilter after
- Permit unauthenticated access to: /api/v1/auth/**, /swagger-ui/**, /api-docs/**
- Require authentication for all /api/v1/** except above
- Configure exception handling
- Disable CSRF

**Filter Order:**
1. PersonalAccessTokenAuthenticationFilter
2. JwtAuthenticationFilter
3. AnonymousAuthenticationFilter
4. UsernamePasswordAuthenticationFilter

**Testing:**
- Test filter ordering
- Test request flow through filters
- Test successful authentication
- Test failed authentication

---

### Task 4.4: Create Permission Checking Aspect
**Objective:** Enforce permissions on controller methods

**Files to Create:**
- `infrastructure/security/RequireTokenPermission.java` (annotation)
- `infrastructure/security/TokenPermissionCheckAspect.java`

**Annotation:**
- @Target(ElementType.METHOD)
- @Retention(RetentionPolicy.RUNTIME)
- value: String (permission code required)

**Aspect:**
- @Aspect @Component
- @Before pointcut targeting @RequireTokenPermission
- Extract permission from annotation
- Get current Authentication from SecurityContext
- Check if user has permission
- Throw AccessDeniedException if missing

**Testing:**
- Test permission allowed
- Test permission denied
- Test unauthenticated rejection
- Test annotation parsing

---

## PHASE 5: Event Handling & Auditing (Weeks 9-10)

### Task 5.1: Create Event Listeners
**Objective:** React to token lifecycle events

**Files to Create:**
- `infrastructure/token/PersonalAccessTokenEventListener.java`

**Event Handlers:**
- handleTokenCreated(PersonalAccessTokenCreatedEvent)
    - Send welcome/confirmation notification to user
    - Log creation in audit log
    - Store in usage log

- handleTokenRevoked(PersonalAccessTokenRevokedEvent)
    - Send revocation notification to user
    - Log revocation reason
    - Clean up any sessions using this token

- handleTokenUsed(PersonalAccessTokenUsedEvent)
    - Record usage in usage log
    - Update lastUsedAt timestamp
    - Check for suspicious activity

**Requirements:**
- @Component, @EventListener annotations
- @Transactional handling
- Call appropriate repositories/services
- Never block on external services (async consideration)

**Testing:**
- Test event listener registration
- Test event handler invocation
- Test side effects (notifications, logs)

---

### Task 5.2: Create Usage Logging Interceptor
**Objective:** Track all API calls using PAT tokens

**Files to Create:**
- `infrastructure/token/TokenUsageLoggingInterceptor.java`

**Requirements:**
- Implement HandlerInterceptor
- preHandle(): Record start time in ThreadLocal
- afterCompletion(): Calculate duration, extract token, record usage
- Store in TokenUsageLogEntity:
    - tokenId (from Authorization header)
    - userId (from SecurityContext)
    - ipAddress (request.getRemoteAddr())
    - endpoint (request.getRequestURI())
    - httpMethod (request.getMethod())
    - statusCode (response.getStatus())
    - usedAt (LocalDateTime.now())

**Flow:**
1. Request arrives
2. preHandle: Start timer
3. Request processed
4. afterCompletion: Log usage if authenticated
5. Clean up ThreadLocal

**Testing:**
- Test pre/post execution hooks
- Test duration calculation
- Test logging of all fields
- Test ThreadLocal cleanup

---

### Task 5.3: Create Audit Trail Service
**Objective:** Maintain complete audit history

**Files to Create:**
- `infrastructure/token/TokenAuditService.java`

**Required Methods:**
- logTokenCreation(tokenId, userId, permissions)
- logTokenUsage(tokenId, userId, ipAddress, endpoint, method)
- logTokenRevocation(tokenId, userId, reason)
- getAuditTrail(tokenId) → List<AuditEntry>
- getRecentActivity(userId) → List<AuditEntry>

**Requirements:**
- Store audit entries with timestamp
- Include actor (userId)
- Include action type (CREATED, USED, REVOKED)
- Include context (IP, endpoint, permissions)
- Enable querying by token or user
- Retention: 90 days minimum

**Testing:**
- Test audit entry creation
- Test audit retrieval
- Test filtering and querying

---

## PHASE 6: REST API & Controllers (Weeks 11-12)

### Task 6.1: Create REST Controller
**Objective:** Expose token management endpoints

**Files to Create:**
- `interfaces/rest/personalAccessToken/PersonalAccessTokenController.java`

**Endpoints Required:**

**POST /api/v1/tokens**
- Authentication: @PreAuthorize("isAuthenticated()")
- Request: CreateTokenRequest
- Response: CreateTokenResponse (201 Created)
- Side effects: Generate token, save, publish events
- Response includes plain token (shown once)

**GET /api/v1/tokens**
- Authentication: @PreAuthorize("isAuthenticated()")
- Query params: optional page, size, status filter
- Response: List<PersonalAccessTokenDto> (200 OK)
- Tokens masked in response

**GET /api/v1/tokens/{tokenId}**
- Authentication: @PreAuthorize("isAuthenticated()")
- Path: tokenId (UUID)
- Response: PersonalAccessTokenDto (200 OK)
- 404 if not found

**DELETE /api/v1/tokens/{tokenId}**
- Authentication: @PreAuthorize("isAuthenticated()")
- Request Body: RevokeTokenRequest (reason required)
- Response: 204 No Content
- Side effects: Revoke token, publish events, send notification

**GET /api/v1/tokens/{tokenId}/usage**
- Authentication: @PreAuthorize("isAuthenticated()")
- Query params: page, size, dateFrom, dateTo
- Response: Page<TokenUsageLogDto>
- Shows recent usage activity

**Requirements:**
- Extract @AuthenticationPrincipal userId
- Validate user owns token (for GET/DELETE)
- Handle exceptions with appropriate HTTP status
- Use DTOs for request/response
- Add @PreAuthorize for permission checks where needed

**Testing:**
- Test CRUD operations
- Test authentication enforcement
- Test authorization (user ownership)
- Test response formats
- Test error scenarios

---

### Task 6.2: Create API Documentation
**Objective:** Document token endpoints with OpenAPI/Swagger

**Files to Create:**
- Update `infrastructure/config/OpenApiConfig.java`

**Documentation:**
- Add @Operation annotations to all controller methods
- Define request/response schemas with @Schema
- Document all query parameters with @Parameter
- Document error responses (401, 403, 404, 409, etc.)
- Include example values and descriptions
- Document security requirements for endpoints
- Create separate group "tokens" in OpenAPI

**Swagger Annotations:**
- @Api on controller class
- @ApiOperation on each method
- @ApiParam on parameters
- @ApiResponse for different responses
- @ApiModelProperty on DTO fields

**Testing:**
- Generate Swagger UI
- Verify all endpoints documented
- Verify schemas correct
- Test Swagger JSON generation

---

### Task 6.3: Create Exception Handling
**Objective:** Handle PAT-specific errors gracefully

**Files to Create:**
- Update `interfaces/exception/GlobalExceptionHandler.java`

**Exception Handlers:**
- TokenNotFoundException
    - Status: 404
    - Message: "Token not found"
    - Error code: ERR_TOKEN_001

- TokenExpiredException
    - Status: 401 (Unauthorized)
    - Message: "Token has expired"
    - Error code: ERR_TOKEN_002

- TokenRevokedException
    - Status: 401
    - Message: "Token has been revoked"
    - Error code: ERR_TOKEN_003

- InvalidPermissionException
    - Status: 403 (Forbidden)
    - Message: "Insufficient permissions for this operation"
    - Error code: ERR_TOKEN_004

- IpNotWhitelistedException
    - Status: 403
    - Message: "Request from unauthorized IP address"
    - Error code: ERR_TOKEN_005

**Response Format:**
- Include HTTP status
- Include error code
- Include message
- Include timestamp
- Include request path

**Testing:**
- Test all exception mappings
- Test response format
- Test error codes
- Test HTTP status codes

---

## PHASE 7: Testing (Weeks 13-14)

### Task 7.1: Unit Tests - Domain Models
**Files to Create:**
- `domain/personalAccessToken/model/TokenIdTest.java`
- `domain/personalAccessToken/model/TokenNameTest.java`
- `domain/personalAccessToken/model/PersonalAccessTokenTest.java`

**Test Coverage:**
- Value object creation and validation
- Immutability verification
- Equals/hashCode contracts
- Business rule enforcement
- State transitions
- Permission checking logic
- Expiration logic
- IP whitelist logic

**Requirements:**
- Use JUnit 5
- Use AssertJ for fluent assertions
- Test both happy path and error cases
- Test edge cases (null, empty, boundary values)

---

### Task 7.2: Integration Tests - Repository Layer
**Files to Create:**
- `infrastructure/persistence/repository/PersonalAccessTokenRepositoryImplTest.java`

**Test Coverage:**
- CRUD operations
- Custom query methods
- Transaction handling
- Mapper functionality
- Database constraints

**Requirements:**
- Use @DataJpaTest or @SpringBootTest
- Use TestContainers for PostgreSQL
- Test data setup/teardown
- Verify database state after operations

---

### Task 7.3: Integration Tests - Application Services
**Files to Create:**
- `application/personalAccessToken/service/CreatePersonalAccessTokenApplicationServiceTest.java`
- `application/personalAccessToken/service/RevokePersonalAccessTokenApplicationServiceTest.java`

**Test Coverage:**
- Command handling
- Event publishing
- Transaction management
- Response generation
- Error scenarios
- Business rule validation

**Requirements:**
- Mock external dependencies
- Verify event publishing
- Test transaction rollback on failure

---

### Task 7.4: Integration Tests - REST API
**Files to Create:**
- `interfaces/rest/personalAccessToken/PersonalAccessTokenControllerTest.java`

**Test Coverage:**
- All HTTP endpoints
- Request/response formats
- Authentication enforcement
- Authorization checks
- Error handling
- HTTP status codes
- JSON serialization/deserialization

**Requirements:**
- Use MockMvc
- Use @SpringBootTest with TestContainers
- Test with valid/invalid authentication
- Verify response schemas

---

### Task 7.5: End-to-End Tests
**Files to Create:**
- `PersonalAccessTokenE2ETest.java`

**Scenarios:**
1. Create token → Use token → Verify usage logged
2. Create token → Revoke → Try to use → Verify rejection
3. Create token with expiration → Wait (mock time) → Try to use → Verify rejection
4. Create token with IP whitelist → Try from different IP → Verify rejection
5. Create token with limited permissions → Try unauthorized operation → Verify rejection
6. Create multiple tokens → List → Verify all present
7. Suspicious activity → Token auto-revoked → Verify

**Requirements:**
- Use TestContainers for infrastructure
- Use MockMvc or REST Assured for API calls
- Mock time progression
- Verify complete workflows

---

## PHASE 8: Documentation & Deployment (Weeks 15-16)

### Task 8.1: Create README Documentation
**File to Create:**
- `PAT_IMPLEMENTATION_GUIDE.md`

**Contents:**
- Overview and use cases
- Feature list
- Security model
- API quick start guide
- Token lifecycle diagram
- Permission list
- Best practices
- Troubleshooting guide

---

### Task 8.2: Create API Documentation
**File to Create:**
- `PAT_API_REFERENCE.md`

**Contents:**
- Authentication flow
- All endpoints with examples
- Request/response schemas
- Error codes and meanings
- Rate limiting policy
- Example curl commands
- Example client code (Java, Python, JavaScript)

---

### Task 8.3: Create Security Documentation
**File to Create:**
- `PAT_SECURITY_GUIDE.md`

**Contents:**
- Token storage best practices
- Transmission security
- Token generation process
- Expiration policy
- Revocation process
- IP whitelisting usage
- Permission model
- Suspicious activity detection
- Incident response procedures

---

### Task 8.4: Create Developer Guide
**File to Create:**
- `PAT_DEVELOPER_GUIDE.md`

**Contents:**
- Architecture overview
- Module organization
- Key classes and responsibilities
- Adding new permissions
- Extending token functionality
- Testing guidelines
- Integration examples
- Common issues and solutions

---

### Task 8.5: Database Migration Strategy
**Objective:** Plan production deployment

**Documentation:**
- Flyway migration versioning
- Rollback procedures
- Data backup requirements
- Index creation strategy
- Performance considerations
- Monitoring queries
- Retention policies for logs

---

### Task 8.6: Monitoring & Alerting
**Objective:** Setup operational monitoring

**Items to Setup:**
- Token creation metrics
- Token revocation rate
- Suspicious activity alerts
- Failed authentication attempts
- API latency metrics
- Database query performance
- Log aggregation

---

## PHASE 9: Optional Enhancements (Weeks 17-18)

### Task 9.1: Token Refresh Mechanism
**Objective:** Allow tokens to be renewed before expiration

**Requirements:**
- Endpoint to refresh token (generates new one)
- Keep old token active for grace period
- Log refresh events
- Notify user of refresh

---

### Task 9.2: Rate Limiting Per Token
**Objective:** Prevent token abuse

**Requirements:**
- Limit requests per token per minute/hour
- Return 429 Too Many Requests when limit exceeded
- Configurable limits per permission level
- Auto-disable token after repeated violations

---

### Task 9.3: Token Scope Limiting
**Objective:** Further restrict token usage

**Requirements:**
- Limit to specific endpoints
- Limit to specific HTTP methods
- Limit to specific resource IDs
- Combine with existing permissions

---

### Task 9.4: Admin Dashboard
**Objective:** Token management UI

**Requirements:**
- View all tokens (admin)
- Revoke tokens (admin)
- View usage analytics
- See suspicious activity
- Configure system settings

---

## Summary Checklist

**Phase 1: Domain (2 weeks)**
- [ ] Value objects created
- [ ] Enums defined
- [ ] Entity classes built
- [ ] Aggregate root implemented
- [ ] Domain events defined
- [ ] Repository interface created
- [ ] Domain service implemented

**Phase 2: Infrastructure (2 weeks)**
- [ ] JPA entities created
- [ ] JPA repositories implemented
- [ ] Mappers built
- [ ] Repository implementation created
- [ ] Database migrations written

**Phase 3: Application (2 weeks)**
- [ ] Commands and queries defined
- [ ] DTOs created
- [ ] Application services implemented
- [ ] Security service implemented

**Phase 4: Security (2 weeks)**
- [ ] Authentication filter created
- [ ] Permission constants defined
- [ ] Security configuration updated
- [ ] Permission checking aspect implemented

**Phase 5: Events (2 weeks)**
- [ ] Event listeners implemented
- [ ] Usage logging interceptor created
- [ ] Audit trail service built

**Phase 6: REST API (2 weeks)**
- [ ] Controller implemented
- [ ] API documented
- [ ] Exception handling configured

**Phase 7: Testing (2 weeks)**
- [ ] Unit tests written
- [ ] Integration tests written
- [ ] E2E tests written
- [ ] Test coverage >80%

**Phase 8: Documentation (2 weeks)**
- [ ] README created
- [ ] API docs written
- [ ] Security guide created
- [ ] Developer guide written

**Phase 9: Optional (2 weeks)**
- [ ] Optional enhancements implemented
- [ ] Performance tuning done
- [ ] Load testing completed
- [ ] Production ready

---

## Detailed Task Breakdown by Week

### Week 1: Value Objects & Enums
**Monday-Tuesday:**
- Create TokenId class with UUID wrapping
- Create TokenName with validation (max 100 chars)
- Unit tests for both value objects
- Ensure immutability and equals/hashCode

**Wednesday-Thursday:**
- Create PermissionId similar to TokenId
- Create TokenStatus enum with 3 states
- Create TokenPermission entity class
- Unit tests for all new classes

**Friday:**
- Code review
- Refactor based on feedback
- Documentation of value objects

---

### Week 2: Aggregate & Events
**Monday-Tuesday:**
- Create PersonalAccessToken aggregate root
- Implement factory method create()
- Implement business rule validation

**Wednesday:**
- Implement revoke(), recordUsage() methods
- Implement permission checking logic
- Implement IP whitelist logic

**Thursday:**
- Create domain event base class
- Create 3 event classes (Created, Revoked, Used)
- Implement event publishing in aggregate

**Friday:**
- Create PersonalAccessTokenRepository interface
- Create PersonalAccessTokenDomainService
- All unit tests
- Code review

---

### Week 3: JPA Layer
**Monday-Tuesday:**
- Create PersonalAccessTokenEntity with all fields
- Create TokenPermissionEntity as embeddable
- Create TokenUsageLogEntity
- Setup proper indexes and constraints

**Wednesday-Thursday:**
- Create PersonalAccessTokenJpaRepository
- Create TokenUsageLogJpaRepository
- Write custom @Query methods
- Test all query methods

**Friday:**
- Create PersonalAccessTokenMapper
- Create PersonalAccessTokenRepositoryImpl
- Integration tests
- Code review

---

### Week 4: Persistence & Migrations
**Monday-Tuesday:**
- Write Flyway migration for schema
- Test schema creation
- Test data insertion

**Wednesday:**
- Create migration for indexes
- Create migration for constraints
- Test rollback procedures

**Thursday-Friday:**
- Test complete CRUD flow
- Performance testing
- Documentation of schema
- Code review

---

### Week 5: Commands & Application Services
**Monday-Tuesday:**
- Create CreatePersonalAccessTokenCommand
- Create RevokePersonalAccessTokenCommand
- Create GetPersonalAccessTokensQuery
- Add validation annotations

**Wednesday:**
- Create all DTOs (Request/Response)
- Add validation annotations to DTOs
- Serialization/deserialization tests

**Thursday:**
- Create CreateApplicationService
- Implement token generation
- Implement event publishing
- Unit tests

**Friday:**
- Create RevokeApplicationService
- Create QueryService
- Integration tests
- Code review

---

### Week 6: Security Service
**Monday-Tuesday:**
- Create TokenSecurityService
- Implement generateSecureToken()
- Implement hashToken()
- Implement suspicious activity detection

**Wednesday-Thursday:**
- Implement validateTokenPermissions()
- Implement validateTokenStrength()
- Unit tests for all methods
- Test hashing consistency

**Friday:**
- Create scheduled cleanup job
- Test cleanup execution
- Integration with domain service
- Code review

---

### Week 7: Authentication Filter
**Monday-Tuesday:**
- Create PersonalAccessTokenAuthenticationFilter
- Implement doFilterInternal()
- Extract token from Authorization header
- Validate token format

**Wednesday:**
- Look up token in repository
- Validate status, expiration, IP
- Create UsernamePasswordAuthenticationToken
- Set in SecurityContext

**Thursday:**
- Exception handling
- Test valid token flow
- Test invalid token rejection
- Test expired token handling

**Friday:**
- Test IP whitelist enforcement
- Integration with filter chain
- Performance testing
- Code review

---

### Week 8: Security Configuration
**Monday-Tuesday:**
- Create TokenPermissionConstants
- Define all permission codes
- Create permission category groups
- Create helper methods

**Wednesday-Thursday:**
- Update SecurityConfig to include PAT filter
- Configure filter order (PAT before JWT)
- Configure endpoint permissions
- CORS and CSRF settings

**Friday:**
- Create permission checking aspect
- Create @RequireTokenPermission annotation
- Test annotation-based checks
- Integration testing
- Code review

---

### Week 9: Event Handling
**Monday-Tuesday:**
- Create PersonalAccessTokenEventListener
- Implement handleTokenCreated()
- Implement handleTokenRevoked()
- Implement handleTokenUsed()

**Wednesday-Thursday:**
- Create TokenUsageLoggingInterceptor
- Implement preHandle() and afterCompletion()
- Extract and log token usage details
- ThreadLocal cleanup

**Friday:**
- Create TokenAuditService
- Implement audit trail logging
- Query audit logs
- Testing of all components
- Code review

---

### Week 10: Audit & Monitoring
**Monday-Tuesday:**
- Enhance audit service with retention
- Create audit trail queries
- Create activity reports
- Test audit functionality

**Wednesday-Thursday:**
- Setup usage log aggregation
- Create analytics queries
- Test query performance
- Add indexes if needed

**Friday:**
- Monitoring metrics setup
- Alert configuration
- Dashboard queries
- Performance testing
- Code review

---

### Week 11: REST Controller
**Monday-Tuesday:**
- Create PersonalAccessTokenController
- Implement POST /api/v1/tokens
- Implement GET /api/v1/tokens
- Request validation

**Wednesday:**
- Implement GET /api/v1/tokens/{tokenId}
- Implement DELETE /api/v1/tokens/{tokenId}
- Authorization checks
- Error handling

**Thursday:**
- Implement GET /api/v1/tokens/{tokenId}/usage
- Pagination support
- Date range filtering
- Response formatting

**Friday:**
- Integration tests for all endpoints
- Authentication testing
- Authorization testing
- Code review

---

### Week 12: API Documentation & Errors
**Monday-Tuesday:**
- Add OpenAPI/Swagger annotations
- Document all endpoints
- Create request/response examples
- Document error responses

**Wednesday-Thursday:**
- Create exception handlers
- Map exceptions to error codes
- Create error response DTOs
- Test error scenarios

**Friday:**
- Generate Swagger UI
- Verify documentation completeness
- Test error responses
- API documentation review
- Code review

---

### Week 13: Unit Tests
**Monday-Tuesday:**
- Unit tests for all value objects
- Unit tests for TokenStatus enum
- Unit tests for TokenPermission
- Unit tests for aggregate root

**Wednesday-Thursday:**
- Test business rule enforcement
- Test state transitions
- Test permission checking
- Test expiration logic
- Test IP whitelist logic

**Friday:**
- Verify >90% code coverage
- Mutation testing (if available)
- Performance testing of unit tests
- Code review

---

### Week 14: Integration & E2E Tests
**Monday-Tuesday:**
- Repository layer integration tests
- CRUD operation tests
- Custom query tests
- Transaction tests

**Wednesday:**
- Application service integration tests
- Event publishing tests
- Transaction rollback tests
- Error scenario tests

**Thursday:**
- REST API integration tests
- End-to-end workflow tests
- Authentication/authorization tests
- Performance testing

**Friday:**
- E2E scenario tests
- Suspicious activity detection tests
- Complete workflow tests
- Coverage verification >85%
- Code review

---

### Week 15: Documentation
**Monday-Tuesday:**
- Create comprehensive README
- Architecture overview documentation
- Feature list and benefits
- Security model documentation

**Wednesday-Thursday:**
- API reference documentation
- Example curl commands
- Example client code (Java, Python, JS)
- Troubleshooting guide

**Friday:**
- Security best practices guide
- Developer integration guide
- Migration guide
- FAQ documentation
- Code review

---

### Week 16: Security & Deployment
**Monday-Tuesday:**
- Security audit of code
- Penetration testing scenarios
- Vulnerability assessment
- Fix identified issues

**Wednesday-Thursday:**
- Database migration testing in staging
- Performance load testing
- Backup/restore procedures
- Monitoring setup verification

**Friday:**
- Deployment runbook creation
- Rollback procedures documented
- Production checklist
- Team training
- Final code review

---

### Week 17: Optional Enhancement - Token Refresh
**Monday-Tuesday:**
- Design token refresh mechanism
- Create RefreshTokenCommand
- Implement refresh endpoint
- Old token grace period

**Wednesday-Thursday:**
- Implement refresh logic
- Update domain service
- Add tests
- Performance testing

**Friday:**
- Integration with existing flow
- Documentation
- Code review

---

### Week 18: Optional Enhancement - Rate Limiting
**Monday-Tuesday:**
- Design rate limiting strategy
- Per-token request limits
- Per-permission level limits
- Auto-disable on violations

**Wednesday-Thursday:**
- Implement rate limiting
- Add to authentication filter
- Handle 429 responses
- Test rate limiting

**Friday:**
- Integration with audit logging
- Monitoring of rate limits
- Admin override capabilities
- Code review

---

## Team Role Allocation

### Backend Developer (Senior)
- Weeks 1-2: Domain models and aggregates
- Weeks 7-8: Authentication and security
- Weeks 15-16: Security review and deployment

### Backend Developer (Mid-level)
- Weeks 3-4: Persistence layer
- Weeks 5-6: Application services
- Weeks 11-12: REST API

### Backend Developer (Junior)
- Weeks 9-10: Event handling and auditing
- Weeks 13-14: Testing
- Weeks 17-18: Optional enhancements

### QA/Test Engineer
- Parallel to development: Create test cases
- Weeks 13-14: Primary focus on testing
- Weeks 15-16: Stress testing and security testing

### DevOps/SRE
- Week 4: Database migrations strategy
- Weeks 15-16: Deployment preparation
- Monitoring and alerting setup

---

## Key Milestones

**End of Week 2:**
- ✅ Complete domain layer
- ✅ All domain classes unit tested
- ✅ Ready for infrastructure implementation

**End of Week 4:**
- ✅ Complete persistence layer
- ✅ Database schema created
- ✅ Repository layer tested
- ✅ Ready for application services

**End of Week 6:**
- ✅ Application services complete
- ✅ Business logic layer complete
- ✅ Security service operational
- ✅ Ready for REST API

**End of Week 8:**
- ✅ Authentication and authorization complete
- ✅ Security filter chain working
- ✅ Permission checks in place
- ✅ Ready for API development

**End of Week 10:**
- ✅ Event handling operational
- ✅ Audit trail working
- ✅ Usage logging complete
- ✅ Monitoring setup

**End of Week 12:**
- ✅ REST API complete
- ✅ All endpoints documented
- ✅ Error handling in place
- ✅ Ready for testing

**End of Week 14:**
- ✅ >85% test coverage
- ✅ All integration tests passing
- ✅ E2E workflows verified
- ✅ Ready for documentation

**End of Week 16:**
- ✅ All documentation complete
- ✅ Security audit passed
- ✅ Production deployment ready
- ✅ Staging environment tested

---

## Risk Mitigation

### Technical Risks

**Risk: Token hashing issues**
- Mitigation: Use proven BCrypt library, test hashing consistency
- Owner: Senior developer
- Contingency: Code review by security team

**Risk: Performance with large token datasets**
- Mitigation: Create proper indexes, performance test
- Owner: Mid-level developer
- Contingency: Query optimization or caching

**Risk: Race conditions in concurrent token operations**
- Mitigation: Database-level constraints, transaction testing
- Owner: Senior developer
- Contingency: Pessimistic locking if needed

**Risk: Security vulnerabilities in authentication**
- Mitigation: Security audit, penetration testing
- Owner: Security team + Senior developer
- Contingency: External security consultant

### Schedule Risks

**Risk: Domain layer takes longer than expected**
- Mitigation: Daily standups, early escalation
- Contingency: Reduce optional enhancements scope

**Risk: Testing reveals major issues**
- Mitigation: Early integration testing, test-driven approach
- Contingency: Extend testing phase by 1 week

**Risk: Team member unavailability**
- Mitigation: Cross-training, pair programming
- Contingency: Adjust timeline and scope

---

## Success Criteria

**Functional Requirements Met:**
- ✅ Create tokens with specific permissions
- ✅ Authenticate requests with tokens
- ✅ Revoke tokens instantly
- ✅ Track token usage
- ✅ Enforce expiration
- ✅ IP whitelist support

**Non-Functional Requirements Met:**
- ✅ >85% test coverage
- ✅ Sub-100ms authentication latency
- ✅ Support 1000+ concurrent tokens
- ✅ All security best practices followed
- ✅ Complete documentation
- ✅ Zero critical security vulnerabilities

**Quality Metrics:**
- ✅ Code review approval rate 100%
- ✅ Production deployment with zero rollbacks
- ✅ Customer satisfaction >4/5
- ✅ No critical production issues in first month

---

## Go-Live Checklist

**Pre-Deployment (1 week before):**
- [ ] All tests passing
- [ ] Staging environment tested
- [ ] Monitoring and alerts configured
- [ ] Runbook completed
- [ ] Rollback procedure tested
- [ ] Backup and restore tested
- [ ] Security audit passed
- [ ] Performance load test completed
- [ ] Team training completed
- [ ] Stakeholder sign-off received

**Deployment Day:**
- [ ] Database migrations applied
- [ ] Code deployed to production
- [ ] Health checks passing
- [ ] Smoke tests passing
- [ ] Monitoring showing normal metrics
- [ ] Support team on standby
- [ ] Rollback team on call

**Post-Deployment (1 week after):**
- [ ] Usage metrics monitored
- [ ] Error rates normal
- [ ] Performance acceptable
- [ ] Customer feedback collected
- [ ] Any bugs documented and fixed
- [ ] Documentation updated with real metrics

---

## Continuous Improvement

**Month 1 Post-Launch:**
- Collect user feedback
- Monitor performance metrics
- Identify improvement areas
- Plan enhancements

**Month 2-3:**
- Implement optional enhancements
- Performance optimization
- Enhanced monitoring
- Advanced features

**Ongoing:**
- Security updates
- Dependency updates
- Performance tuning
- User training and support