# Delivery System - Feature-Based Architecture

## Project Structure

```
delivery-system/
│
├── src/
│   ├── main/
│   │   ├── java/com/yourcompany/delivery/
│   │   │   │
│   │   │   ├── domain/                           # Domain Layer (Core Business Logic)
│   │   │   │   ├── order/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Order.java
│   │   │   │   │   │   ├── OrderId.java
│   │   │   │   │   │   ├── OrderItem.java
│   │   │   │   │   │   ├── OrderItemId.java
│   │   │   │   │   │   ├── OrderStatus.java
│   │   │   │   │   │   ├── OrderTotal.java
│   │   │   │   │   │   ├── ShippingAddress.java
│   │   │   │   │   │   └── OrderPaymentInfo.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── OrderRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── OrderDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── OrderCreatedEvent.java
│   │   │   │   │       ├── OrderConfirmedEvent.java
│   │   │   │   │       ├── OrderCancelledEvent.java
│   │   │   │   │       └── OrderDeliveredEvent.java
│   │   │   │   │
│   │   │   │   ├── delivery/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Delivery.java
│   │   │   │   │   │   ├── DeliveryId.java
│   │   │   │   │   │   ├── DeliveryStatus.java
│   │   │   │   │   │   ├── DeliveryRoute.java
│   │   │   │   │   │   ├── RouteId.java
│   │   │   │   │   │   ├── Waypoint.java
│   │   │   │   │   │   ├── Location.java
│   │   │   │   │   │   ├── DeliverySchedule.java
│   │   │   │   │   │   └── TrackingInfo.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   ├── DeliveryRepository.java
│   │   │   │   │   │   └── DeliveryRouteRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── DeliveryDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── DeliveryAssignedEvent.java
│   │   │   │   │       ├── DeliveryStartedEvent.java
│   │   │   │   │       ├── DeliveryCompletedEvent.java
│   │   │   │   │       └── DeliveryFailedEvent.java
│   │   │   │   │
│   │   │   │   ├── driver/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Driver.java
│   │   │   │   │   │   ├── DriverId.java
│   │   │   │   │   │   ├── DriverStatus.java
│   │   │   │   │   │   ├── Vehicle.java
│   │   │   │   │   │   ├── VehicleId.java
│   │   │   │   │   │   ├── VehicleType.java
│   │   │   │   │   │   ├── License.java
│   │   │   │   │   │   ├── DriverRating.java
│   │   │   │   │   │   └── DriverLocation.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── DriverRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── DriverDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── DriverRegisteredEvent.java
│   │   │   │   │       ├── DriverStatusChangedEvent.java
│   │   │   │   │       └── DriverRatedEvent.java
│   │   │   │   │
│   │   │   │   ├── customer/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Customer.java
│   │   │   │   │   │   ├── CustomerId.java
│   │   │   │   │   │   ├── CustomerProfile.java
│   │   │   │   │   │   ├── Address.java
│   │   │   │   │   │   ├── AddressId.java
│   │   │   │   │   │   ├── PaymentMethod.java
│   │   │   │   │   │   ├── PaymentMethodId.java
│   │   │   │   │   │   └── CustomerPreference.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── CustomerRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── CustomerDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── CustomerRegisteredEvent.java
│   │   │   │   │       └── CustomerProfileUpdatedEvent.java
│   │   │   │   │
│   │   │   │   ├── payment/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Payment.java
│   │   │   │   │   │   ├── PaymentId.java
│   │   │   │   │   │   ├── PaymentStatus.java
│   │   │   │   │   │   ├── PaymentMethod.java
│   │   │   │   │   │   ├── Amount.java
│   │   │   │   │   │   ├── PaymentTransaction.java
│   │   │   │   │   │   └── TransactionId.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── PaymentRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── PaymentDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── PaymentInitiatedEvent.java
│   │   │   │   │       ├── PaymentProcessedEvent.java
│   │   │   │   │       └── PaymentFailedEvent.java
│   │   │   │   │
│   │   │   │   ├── notification/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Notification.java
│   │   │   │   │   │   ├── NotificationId.java
│   │   │   │   │   │   ├── NotificationType.java
│   │   │   │   │   │   ├── NotificationChannel.java
│   │   │   │   │   │   └── NotificationTemplate.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── NotificationRepository.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── NotificationDomainService.java
│   │   │   │   │
│   │   │   │   ├── merchant/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Merchant.java
│   │   │   │   │   │   ├── MerchantId.java
│   │   │   │   │   │   ├── MerchantType.java
│   │   │   │   │   │   ├── MerchantStatus.java
│   │   │   │   │   │   ├── MerchantProfile.java
│   │   │   │   │   │   ├── BusinessInfo.java
│   │   │   │   │   │   └── OperatingHours.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── MerchantRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── MerchantDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── MerchantRegisteredEvent.java
│   │   │   │   │       └── MerchantApprovedEvent.java
│   │   │   │   │
│   │   │   │   ├── product/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Product.java
│   │   │   │   │   │   ├── ProductId.java
│   │   │   │   │   │   ├── Category.java
│   │   │   │   │   │   ├── CategoryId.java
│   │   │   │   │   │   ├── ProductVariant.java
│   │   │   │   │   │   ├── VariantId.java
│   │   │   │   │   │   ├── Price.java
│   │   │   │   │   │   ├── Stock.java
│   │   │   │   │   │   └── ProductReview.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   ├── ProductRepository.java
│   │   │   │   │   │   └── CategoryRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── ProductDomainService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── ProductCreatedEvent.java
│   │   │   │   │       └── ProductStockUpdatedEvent.java
│   │   │   │   │
│   │   │   │   ├── rating/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Rating.java
│   │   │   │   │   │   ├── RatingId.java
│   │   │   │   │   │   ├── RatingValue.java
│   │   │   │   │   │   ├── RatingType.java
│   │   │   │   │   │   └── ReviewText.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── RatingRepository.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── RatingDomainService.java
│   │   │   │   │
│   │   │   │   ├── promocode/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Promocode.java
│   │   │   │   │   │   ├── PromoCodeId.java
│   │   │   │   │   │   ├── DiscountType.java
│   │   │   │   │   │   ├── DiscountValue.java
│   │   │   │   │   │   ├── UsageLimit.java
│   │   │   │   │   │   └── ValidityPeriod.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── PromocodeRepository.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── PromocodeDomainService.java
│   │   │   │   │
│   │   │   │   ├── webhook/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── Webhook.java
│   │   │   │   │   │   ├── WebhookId.java
│   │   │   │   │   │   ├── WebhookEvent.java
│   │   │   │   │   │   ├── WebhookDelivery.java
│   │   │   │   │   │   └── RetryPolicy.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── WebhookRepository.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── WebhookDomainService.java
│   │   │   │   │
│   │   │   │   ├── support/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── SupportTicket.java
│   │   │   │   │   │   ├── TicketId.java
│   │   │   │   │   │   ├── TicketStatus.java
│   │   │   │   │   │   ├── TicketCategory.java
│   │   │   │   │   │   ├── TicketPriority.java
│   │   │   │   │   │   └── TicketMessage.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── SupportTicketRepository.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── SupportTicketDomainService.java
│   │   │   │   │
│   │   │   │   ├── token/
│   │   │   │   │   ├── model/
│   │   │   │   │   │   ├── PersonalAccessToken.java
│   │   │   │   │   │   ├── TokenId.java
│   │   │   │   │   │   ├── TokenName.java
│   │   │   │   │   │   ├── TokenPermission.java
│   │   │   │   │   │   ├── PermissionId.java
│   │   │   │   │   │   ├── TokenStatus.java
│   │   │   │   │   │   └── TokenUsageLog.java
│   │   │   │   │   ├── repository/
│   │   │   │   │   │   └── PersonalAccessTokenRepository.java
│   │   │   │   │   ├── service/
│   │   │   │   │   │   ├── PersonalAccessTokenDomainService.java
│   │   │   │   │   │   └── TokenSecurityService.java
│   │   │   │   │   └── event/
│   │   │   │   │       ├── PersonalAccessTokenCreatedEvent.java
│   │   │   │   │       ├── PersonalAccessTokenRevokedEvent.java
│   │   │   │   │       └── PersonalAccessTokenUsedEvent.java
│   │   │   │   │
│   │   │   │   └── shared/
│   │   │   │       ├── valueobject/
│   │   │   │       │   ├── AuditInfo.java
│   │   │   │       │   ├── Metadata.java
│   │   │   │       │   ├── Money.java
│   │   │   │       │   ├── Distance.java
│   │   │   │       │   ├── Email.java
│   │   │   │       │   ├── PhoneNumber.java
│   │   │   │       │   ├── Coordinates.java
│   │   │   │       │   └── TimeRange.java
│   │   │   │       ├── exception/
│   │   │   │       │   ├── DomainException.java
│   │   │   │       │   ├── BusinessRuleException.java
│   │   │   │       │   ├── DeliveryException.java
│   │   │   │       │   ├── InvalidStateException.java
│   │   │   │       │   └── ResourceNotFoundException.java
│   │   │   │       └── base/
│   │   │   │           ├── AggregateRoot.java
│   │   │   │           ├── Entity.java
│   │   │   │           ├── ValueObject.java
│   │   │   │           ├── DomainEvent.java
│   │   │   │           └── Repository.java
│   │   │   │
│   │   │   ├── application/                      # Application Layer (Use Cases)
│   │   │   │   ├── order/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreateOrderCommand.java
│   │   │   │   │   │   ├── ConfirmOrderCommand.java
│   │   │   │   │   │   ├── CancelOrderCommand.java
│   │   │   │   │   │   ├── UpdateOrderCommand.java
│   │   │   │   │   │   └── AddOrderItemCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetOrderQuery.java
│   │   │   │   │   │   ├── ListOrdersQuery.java
│   │   │   │   │   │   ├── GetOrderStatusQuery.java
│   │   │   │   │   │   └── GetOrderHistoryQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── OrderDto.java
│   │   │   │   │   │   ├── OrderItemDto.java
│   │   │   │   │   │   ├── CreateOrderRequest.java
│   │   │   │   │   │   ├── UpdateOrderRequest.java
│   │   │   │   │   │   ├── OrderResponse.java
│   │   │   │   │   │   └── OrderSummaryDto.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── OrderApplicationService.java
│   │   │   │   │       ├── OrderQueryService.java
│   │   │   │   │       └── OrderCommandHandler.java
│   │   │   │   │
│   │   │   │   ├── delivery/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreateDeliveryCommand.java
│   │   │   │   │   │   ├── AssignDeliveryCommand.java
│   │   │   │   │   │   ├── UpdateDeliveryStatusCommand.java
│   │   │   │   │   │   ├── UpdateLocationCommand.java
│   │   │   │   │   │   └── CompleteDeliveryCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetDeliveryQuery.java
│   │   │   │   │   │   ├── TrackDeliveryQuery.java
│   │   │   │   │   │   ├── ListDeliveriesQuery.java
│   │   │   │   │   │   └── GetDeliveryHistoryQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── DeliveryDto.java
│   │   │   │   │   │   ├── DeliveryRouteDto.java
│   │   │   │   │   │   ├── TrackingInfoDto.java
│   │   │   │   │   │   ├── DeliveryResponse.java
│   │   │   │   │   │   └── LocationUpdateDto.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── DeliveryApplicationService.java
│   │   │   │   │       ├── DeliveryQueryService.java
│   │   │   │   │       └── TrackingService.java
│   │   │   │   │
│   │   │   │   ├── driver/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── RegisterDriverCommand.java
│   │   │   │   │   │   ├── UpdateDriverStatusCommand.java
│   │   │   │   │   │   ├── AssignVehicleCommand.java
│   │   │   │   │   │   ├── UpdateDriverLocationCommand.java
│   │   │   │   │   │   └── RateDriverCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetDriverQuery.java
│   │   │   │   │   │   ├── ListAvailableDriversQuery.java
│   │   │   │   │   │   ├── GetDriverRatingQuery.java
│   │   │   │   │   │   └── GetDriverStatsQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── DriverDto.java
│   │   │   │   │   │   ├── VehicleDto.java
│   │   │   │   │   │   ├── DriverResponse.java
│   │   │   │   │   │   ├── DriverRegistrationRequest.java
│   │   │   │   │   │   └── DriverLocationDto.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── DriverApplicationService.java
│   │   │   │   │       ├── DriverQueryService.java
│   │   │   │   │       └── DriverAssignmentService.java
│   │   │   │   │
│   │   │   │   ├── customer/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── RegisterCustomerCommand.java
│   │   │   │   │   │   ├── UpdateCustomerProfileCommand.java
│   │   │   │   │   │   ├── AddAddressCommand.java
│   │   │   │   │   │   ├── UpdateAddressCommand.java
│   │   │   │   │   │   └── DeleteAddressCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetCustomerQuery.java
│   │   │   │   │   │   ├── ListCustomersQuery.java
│   │   │   │   │   │   └── GetCustomerAddressesQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── CustomerDto.java
│   │   │   │   │   │   ├── CustomerResponse.java
│   │   │   │   │   │   ├── CustomerRegistrationRequest.java
│   │   │   │   │   │   ├── AddressDto.java
│   │   │   │   │   │   └── CustomerProfileDto.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── CustomerApplicationService.java
│   │   │   │   │       └── CustomerQueryService.java
│   │   │   │   │
│   │   │   │   ├── payment/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── InitiatePaymentCommand.java
│   │   │   │   │   │   ├── ProcessPaymentCommand.java
│   │   │   │   │   │   ├── RefundPaymentCommand.java
│   │   │   │   │   │   └── CancelPaymentCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetPaymentQuery.java
│   │   │   │   │   │   ├── ListPaymentsQuery.java
│   │   │   │   │   │   └── GetPaymentStatusQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── PaymentDto.java
│   │   │   │   │   │   ├── PaymentResponse.java
│   │   │   │   │   │   ├── PaymentRequest.java
│   │   │   │   │   │   └── RefundRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── PaymentApplicationService.java
│   │   │   │   │       └── PaymentQueryService.java
│   │   │   │   │
│   │   │   │   ├── notification/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── SendNotificationCommand.java
│   │   │   │   │   │   └── ScheduleNotificationCommand.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── NotificationDto.java
│   │   │   │   │   │   └── NotificationRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── NotificationApplicationService.java
│   │   │   │   │
│   │   │   │   ├── merchant/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── RegisterMerchantCommand.java
│   │   │   │   │   │   ├── ApproveMerchantCommand.java
│   │   │   │   │   │   └── UpdateMerchantCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetMerchantQuery.java
│   │   │   │   │   │   └── ListMerchantsQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── MerchantDto.java
│   │   │   │   │   │   ├── MerchantResponse.java
│   │   │   │   │   │   └── MerchantRegistrationRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── MerchantApplicationService.java
│   │   │   │   │       └── MerchantQueryService.java
│   │   │   │   │
│   │   │   │   ├── product/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreateProductCommand.java
│   │   │   │   │   │   ├── UpdateProductCommand.java
│   │   │   │   │   │   ├── DeleteProductCommand.java
│   │   │   │   │   │   └── UpdateStockCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetProductQuery.java
│   │   │   │   │   │   ├── ListProductsQuery.java
│   │   │   │   │   │   └── SearchProductsQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── ProductDto.java
│   │   │   │   │   │   ├── ProductResponse.java
│   │   │   │   │   │   ├── ProductRequest.java
│   │   │   │   │   │   └── CategoryDto.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── ProductApplicationService.java
│   │   │   │   │       └── ProductQueryService.java
│   │   │   │   │
│   │   │   │   ├── rating/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── SubmitRatingCommand.java
│   │   │   │   │   │   └── UpdateRatingCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetRatingQuery.java
│   │   │   │   │   │   └── ListRatingsQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── RatingDto.java
│   │   │   │   │   │   └── RatingRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── RatingApplicationService.java
│   │   │   │   │
│   │   │   │   ├── promocode/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreatePromocodeCommand.java
│   │   │   │   │   │   └── ApplyPromocodeCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetPromocodeQuery.java
│   │   │   │   │   │   └── ValidatePromocodeQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── PromocodeDto.java
│   │   │   │   │   │   └── PromocodeRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── PromocodeApplicationService.java
│   │   │   │   │
│   │   │   │   ├── webhook/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreateWebhookCommand.java
│   │   │   │   │   │   └── DeleteWebhookCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetWebhookQuery.java
│   │   │   │   │   │   └── ListWebhooksQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── WebhookDto.java
│   │   │   │   │   │   └── WebhookRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── WebhookApplicationService.java
│   │   │   │   │
│   │   │   │   ├── support/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreateTicketCommand.java
│   │   │   │   │   │   ├── UpdateTicketCommand.java
│   │   │   │   │   │   └── ResolveTicketCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetTicketQuery.java
│   │   │   │   │   │   └── ListTicketsQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── SupportTicketDto.java
│   │   │   │   │   │   └── TicketRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       └── SupportTicketApplicationService.java
│   │   │   │   │
│   │   │   │   ├── token/
│   │   │   │   │   ├── command/
│   │   │   │   │   │   ├── CreatePersonalAccessTokenCommand.java
│   │   │   │   │   │   └── RevokePersonalAccessTokenCommand.java
│   │   │   │   │   ├── query/
│   │   │   │   │   │   ├── GetPersonalAccessTokensQuery.java
│   │   │   │   │   │   └── GetTokenUsageQuery.java
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── CreateTokenRequest.java
│   │   │   │   │   │   ├── CreateTokenResponse.java
│   │   │   │   │   │   ├── PersonalAccessTokenDto.java
│   │   │   │   │   │   └── RevokeTokenRequest.java
│   │   │   │   │   └── service/
│   │   │   │   │       ├── CreatePersonalAccessTokenApplicationService.java
│   │   │   │   │       ├── RevokePersonalAccessTokenApplicationService.java
│   │   │   │   │       └── GetPersonalAccessTokensQueryService.java
│   │   │   │   │
│   │   │   │   └── shared/
│   │   │   │       ├── mapper/
│   │   │   │       │   ├── OrderMapper.java
│   │   │   │       │   ├── DeliveryMapper.java
│   │   │   │       │   ├── DriverMapper.java
│   │   │   │       │   ├── CustomerMapper.java
│   │   │   │       │   ├── PaymentMapper.java
│   │   │   │       │   ├── MerchantMapper.java
│   │   │   │       │   ├── ProductMapper.java
│   │   │   │       │   └── TokenMapper.java
│   │   │   │       ├── validation/
│   │   │   │       │   ├── ValidationService.java
│   │   │   │       │   └── BusinessRuleValidator.java
│   │   │   │       └── exception/
│   │   │   │           ├── ApplicationException.java
│   │   │   │           ├── ValidationException.java
│   │   │   │           └── CommandProcessingException.java
│   │   │   │
│   │   │   ├── infrastructure/                   # Infrastructure Layer
│   │   │   │   ├── persistence/
│   │   │   │   │   ├── entity/
│   │   │   │   │   │   ├── OrderEntity.java
│   │   │   │   │   │   ├── OrderItemEntity.java
│   │   │   │   │   │   ├── DeliveryEntity.java
│   │   │   │   │   │   ├── DeliveryRouteEntity.java
│   │   │   │   │   │   ├── DeliveryTrackingEntity.java
│   │   │   │   │   │   ├── DriverEntity.java
│   │   │   │   │   │   ├── VehicleEntity.java
│   │   │   │   │   │   ├── CustomerEntity.java
│   │   │   │   │   │   ├── AddressEntity.java
│   │   │   │   │   │   ├── PaymentEntity.java
│   │   │   │   │   │   ├── PaymentTransactionEntity.java
│   │   │   │   │   │   ├── PaymentMethodEntity.java
│   │   │   │   │   │   ├── NotificationEntity.java
│   │   │   │   │   │   ├── NotificationPreferenceEntity.java
│   │   │   │   │   │   ├── MerchantEntity.java
│   │   │   │   │   │   ├── MerchantAddressEntity.java
│   │   │   │   │   │   ├── ProductEntity.java
│   │   │   │   │   │   ├── ProductVariantEntity.java
│   │   │   │   │   │   ├── CategoryEntity.java
│   │   │   │   │   │   ├── ProductReviewEntity.java
│   │   │   │   │   │   ├── RatingEntity.java
│   │   │   │   │   │   ├── PromocodeEntity.java
│   │   │   │   │   │   ├── PromocodeUsageEntity.java
│   │   │   │   │   │   ├── WebhookEntity.java
│   │   │   │   │   │   ├── WebhookDeliveryEntity.java
│   │   │   │   │   │   ├── SupportTicketEntity.java
│   │   │   │   │   │   ├── PersonalAccessTokenEntity.java
│   │   │   │   │   │   ├── TokenPermissionEntity.java
│   │   │   │   │   │   ├── TokenUsageLogEntity.java
│   │   │   │   │   │   ├── AuditLogEntity.java
│   │   │   │   │   │   └── UserEntity.java
│   │   │   │   │   ├── mapper/
│   │   │   │   │   │   ├── OrderPersistenceMapper.java
│   │   │   │   │   │   ├── DeliveryPersistenceMapper.java
│   │   │   │   │   │   ├── DriverPersistenceMapper.java
│   │   │   │   │   │   ├── CustomerPersistenceMapper.java
│   │   │   │   │   │   ├── PaymentPersistenceMapper.java
│   │   │   │   │   │   ├── NotificationPersistenceMapper.java
│   │   │   │   │   │   ├── MerchantPersistenceMapper.java
│   │   │   │   │   │   ├── ProductPersistenceMapper.java
│   │   │   │   │   │   ├── RatingPersistenceMapper.java
│   │   │   │   │   │   ├── PromocodePersistenceMapper.java
│   │   │   │   │   │   ├── WebhookPersistenceMapper.java
│   │   │   │   │   │   ├── SupportTicketPersistenceMapper.java
│   │   │   │   │   │   └── PersonalAccessTokenPersistenceMapper.java
│   │   │   │   │   └── repository/
│   │   │   │   │       ├── OrderRepositoryImpl.java
│   │   │   │   │       ├── DeliveryRepositoryImpl.java
│   │   │   │   │       ├── DriverRepositoryImpl.java
│   │   │   │   │       ├── CustomerRepositoryImpl.java
│   │   │   │   │       ├── PaymentRepositoryImpl.java
│   │   │   │   │       ├── NotificationRepositoryImpl.java
│   │   │   │   │       ├── MerchantRepositoryImpl.java
│   │   │   │   │       ├── ProductRepositoryImpl.java
│   │   │   │   │       ├── CategoryRepositoryImpl.java
│   │   │   │   │       ├── RatingRepositoryImpl.java
│   │   │   │   │       ├── PromocodeRepositoryImpl.java
│   │   │   │   │       ├── WebhookRepositoryImpl.java
│   │   │   │   │       ├── SupportTicketRepositoryImpl.java
│   │   │   │   │       ├── PersonalAccessTokenRepositoryImpl.java
│   │   │   │   │       ├── TokenUsageLogRepositoryImpl.java
│   │   │   │   │       └── jpa/
│   │   │   │   │           ├── OrderJpaRepository.java
│   │   │   │   │           ├── DeliveryJpaRepository.java
│   │   │   │   │           ├── DriverJpaRepository.java
│   │   │   │   │           ├── CustomerJpaRepository.java
│   │   │   │   │           ├── PaymentJpaRepository.java
│   │   │   │   │           ├── NotificationJpaRepository.java
│   │   │   │   │           ├── MerchantJpaRepository.java
│   │   │   │   │           ├── ProductJpaRepository.java
│   │   │   │   │           ├── CategoryJpaRepository.java
│   │   │   │   │           ├── RatingJpaRepository.java
│   │   │   │   │           ├── PromocodeJpaRepository.java
│   │   │   │   │           ├── WebhookJpaRepository.java
│   │   │   │   │           ├── SupportTicketJpaRepository.java
│   │   │   │   │           ├── PersonalAccessTokenJpaRepository.java
│   │   │   │   │           └── TokenUsageLogJpaRepository.java
│   │   │   │   │
│   │   │   │   ├── security/
│   │   │   │   │   ├── SecurityConfig.java
│   │   │   │   │   ├── JwtTokenProvider.java
│   │   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   │   ├── CustomUserDetailsService.java
│   │   │   │   │   ├── PersonalAccessTokenAuthenticationFilter.java
│   │   │   │   │   ├── TokenPermissionConstants.java
│   │   │   │   │   ├── PasswordEncoder.java
│   │   │   │   │   └── SecurityUtils.java
│   │   │   │   │
│   │   │   │   ├── messaging/
│   │   │   │   │   ├── event/
│   │   │   │   │   │   ├── EventPublisher.java
│   │   │   │   │   │   ├── EventPublisherImpl.java
│   │   │   │   │   │   ├── DomainEventListener.java
│   │   │   │   │   │   ├── OrderEventListener.java
│   │   │   │   │   │   ├── DeliveryEventListener.java
│   │   │   │   │   │   ├── PaymentEventListener.java
│   │   │   │   │   │   └── NotificationEventListener.java
│   │   │   │   │   └── kafka/
│   │   │   │   │       ├── KafkaProducerConfig.java
│   │   │   │   │       ├── KafkaConsumerConfig.java
│   │   │   │   │       ├── OrderEventProducer.java
│   │   │   │   │       └── DeliveryEventConsumer.java
│   │   │   │   │
│   │   │   │   ├── storage/
│   │   │   │   │   ├── FileStorageService.java
│   │   │   │   │   ├── S3StorageService.java
│   │   │   │   │   ├── LocalFileStorageService.java
│   │   │   │   │   └── StorageConfig.java
│   │   │   │   │
│   │   │   │   ├── geolocation/
│   │   │   │   │   ├── GeoLocationService.java
│   │   │   │   │   ├── RouteOptimizationService.java
│   │   │   │   │   ├── DistanceCalculationService.java
│   │   │   │   │   ├── GoogleMapsAdapter.java
│   │   │   │   │   └── GeolocationConfig.java
│   │   │   │   │
│   │   │   │   ├── payment/
│   │   │   │   │   ├── gateway/
│   │   │   │   │   │   ├── PaymentGateway.java
│   │   │   │   │   │   ├── PaymentGatewayAdapter.java
│   │   │   │   │   │   ├── StripePaymentService.java
│   │   │   │   │   │   ├── PayPalPaymentService.java
│   │   │   │   │   │   └── RazorpayPaymentService.java
│   │   │   │   │   └── config/
│   │   │   │   │       └── PaymentGatewayConfig.java
│   │   │   │   │
│   │   │   │   ├── notification/
│   │   │   │   │   ├── email/
│   │   │   │   │   │   ├── EmailService.java
│   │   │   │   │   │   ├── EmailServiceImpl.java
│   │   │   │   │   │   ├── EmailTemplate.java
│   │   │   │   │   │   └── SendGridEmailService.java
│   │   │   │   │   ├── sms/
│   │   │   │   │   │   ├── SmsService.java
│   │   │   │   │   │   ├── SmsServiceImpl.java
│   │   │   │   │   │   └── TwilioSmsService.java
│   │   │   │   │   ├── push/
│   │   │   │   │   │   ├── PushNotificationService.java
│   │   │   │   │   │   ├── FirebasePushService.java
│   │   │   │   │   │   └── PushNotificationConfig.java
│   │   │   │   │   └── config/
│   │   │   │   │       └── NotificationConfig.java
│   │   │   │   │
│   │   │   │   ├── webhook/
│   │   │   │   │   ├── WebhookDeliveryService.java
│   │   │   │   │   ├── WebhookRetryService.java
│   │   │   │   │   ├── WebhookSignatureService.java
│   │   │   │   │   └── WebhookEventListener.java
│   │   │   │   │
│   │   │   │   ├── cache/
│   │   │   │   │   ├── CacheService.java
│   │   │   │   │   ├── RedisCacheService.java
│   │   │   │   │   └── CacheConfig.java
│   │   │   │   │
│   │   │   │   ├── monitoring/
│   │   │   │   │   ├── MetricsService.java
│   │   │   │   │   ├── LoggingInterceptor.java
│   │   │   │   │   └── PerformanceMonitor.java
│   │   │   │   │
│   │   │   │   ├── scheduler/
│   │   │   │   │   ├── ScheduledTasks.java
│   │   │   │   │   ├── DeliveryScheduler.java
│   │   │   │   │   ├── NotificationScheduler.java
│   │   │   │   │   └── TokenCleanupScheduler.java
│   │   │   │   │
│   │   │   │   └── token/
│   │   │   │       ├── TokenUsageLoggingInterceptor.java
│   │   │   │       ├── PersonalAccessTokenEventListener.java
│   │   │   │       └── TokenValidationService.java
│   │   │   │
│   │   │   └── interfaces/                       # Interface Layer (Presentation)
│   │   │       ├── rest/
│   │   │       │   ├── order/
│   │   │       │   │   ├── OrderController.java
│   │   │       │   │   ├── OrderRestMapper.java
│   │   │       │   │   └── OrderQueryController.java
│   │   │       │   ├── delivery/
│   │   │       │   │   ├── DeliveryController.java
│   │   │       │   │   ├── TrackingController.java
│   │   │       │   │   ├── DeliveryRestMapper.java
│   │   │       │   │   └── DeliveryQueryController.java
│   │   │       │   ├── driver/
│   │   │       │   │   ├── DriverController.java
│   │   │       │   │   ├── DriverRestMapper.java
│   │   │       │   │   └── DriverQueryController.java
│   │   │       │   ├── customer/
│   │   │       │   │   ├── CustomerController.java
│   │   │       │   │   ├── CustomerRestMapper.java
│   │   │       │   │   └── CustomerQueryController.java
│   │   │       │   ├── payment/
│   │   │       │   │   ├── PaymentController.java
│   │   │       │   │   ├── PaymentRestMapper.java
│   │   │       │   │   └── PaymentWebhookController.java
│   │   │       │   ├── notification/
│   │   │       │   │   ├── NotificationController.java
│   │   │       │   │   └── NotificationPreferenceController.java
│   │   │       │   ├── merchant/
│   │   │       │   │   ├── MerchantController.java
│   │   │       │   │   ├── MerchantRestMapper.java
│   │   │       │   │   └── MerchantQueryController.java
│   │   │       │   ├── product/
│   │   │       │   │   ├── ProductController.java
│   │   │       │   │   ├── CategoryController.java
│   │   │       │   │   ├── ProductRestMapper.java
│   │   │       │   │   └── ProductSearchController.java
│   │   │       │   ├── rating/
│   │   │       │   │   ├── RatingController.java
│   │   │       │   │   └── RatingRestMapper.java
│   │   │       │   ├── promocode/
│   │   │       │   │   ├── PromocodeController.java
│   │   │       │   │   └── PromocodeRestMapper.java
│   │   │       │   ├── webhook/
│   │   │       │   │   ├── WebhookController.java
│   │   │       │   │   └── WebhookRestMapper.java
│   │   │       │   ├── support/
│   │   │       │   │   ├── SupportTicketController.java
│   │   │       │   │   └── SupportTicketRestMapper.java
│   │   │       │   ├── token/
│   │   │       │   │   ├── PersonalAccessTokenController.java
│   │   │       │   │   └── TokenRestMapper.java
│   │   │       │   └── health/
│   │   │       │       └── HealthCheckController.java
│   │   │       │
│   │   │       ├── graphql/
│   │   │       │   ├── resolver/
│   │   │       │   │   ├── OrderResolver.java
│   │   │       │   │   ├── DeliveryResolver.java
│   │   │       │   │   ├── DriverResolver.java
│   │   │       │   │   └── ProductResolver.java
│   │   │       │   └── schema/
│   │   │       │       └── schema.graphqls
│   │   │       │
│   │   │       ├── websocket/
│   │   │       │   ├── TrackingWebSocketHandler.java
│   │   │       │   ├── NotificationWebSocketHandler.java
│   │   │       │   └── WebSocketConfig.java
│   │   │       │
│   │   │       ├── exception/
│   │   │       │   ├── GlobalExceptionHandler.java
│   │   │       │   ├── ApiError.java
│   │   │       │   ├── DeliveryErrorCode.java
│   │   │       │   ├── ErrorResponse.java
│   │   │       │   └── ValidationErrorResponse.java
│   │   │       │
│   │   │       ├── validator/
│   │   │       │   ├── OrderRequestValidator.java
│   │   │       │   ├── DeliveryRequestValidator.java
│   │   │       │   └── PaymentRequestValidator.java
│   │   │       │
│   │   │       ├── interceptor/
│   │   │       │   ├── RateLimitInterceptor.java
│   │   │       │   ├── AuthenticationInterceptor.java
│   │   │       │   └── LoggingInterceptor.java
│   │   │       │
│   │   │       └── config/
│   │   │           ├── WebConfig.java
│   │   │           ├── WebSecurityConfig.java
│   │   │           ├── OpenApiConfig.java
│   │   │           ├── CorsConfig.java
│   │   │           ├── JacksonConfig.java
│   │   │           └── AsyncConfig.java
│   │   │
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       ├── application-test.yml
│   │       ├── db/
│   │       │   └── migration/
│   │       │       ├── V1__Create_users_table.sql
│   │       │       ├── V2__Create_customers_table.sql
│   │       │       ├── V3__Create_addresses_table.sql
│   │       │       ├── V4__Create_drivers_table.sql
│   │       │       ├── V5__Create_vehicles_table.sql
│   │       │       ├── V6__Create_orders_table.sql
│   │       │       ├── V7__Create_order_items_table.sql
│   │       │       ├── V8__Create_merchants_table.sql
│   │       │       ├── V9__Create_products_table.sql
│   │       │       ├── V10__Create_deliveries_table.sql
│   │       │       ├── V11__Create_delivery_routes_table.sql
│   │       │       ├── V12__Create_delivery_tracking_table.sql
│   │       │       ├── V13__Create_payments_table.sql
│   │       │       ├── V14__Create_notifications_table.sql
│   │       │       ├── V15__Create_ratings_table.sql
│   │       │       ├── V16__Create_promocodes_table.sql
│   │       │       ├── V17__Create_webhooks_table.sql
│   │       │       ├── V18__Create_support_tickets_table.sql
│   │       │       ├── V19__Create_personal_access_tokens_table.sql
│   │       │       └── V20__Create_audit_logs_table.sql
│   │       ├── templates/
│   │       │   ├── email/
│   │       │   │   ├── order_confirmation.html
│   │       │   │   ├── delivery_notification.html
│   │       │   │   └── password_reset.html
│   │       │   └── sms/
│   │       │       └── otp_template.txt
│   │       ├── static/
│   │       │   ├── css/
│   │       │   ├── js/
│   │       │   └── images/
│   │       ├── graphql/
│   │       │   └── schema.graphqls
│   │       └── messages/
│   │           ├── messages.properties
│   │           ├── messages_en.properties
│   │           └── messages_es.properties
│   │
│   └── test/
│       ├── java/com/yourcompany/delivery/
│       │   ├── domain/
│       │   │   ├── order/
│       │   │   │   ├── model/
│       │   │   │   │   ├── OrderTest.java
│       │   │   │   │   └── OrderItemTest.java
│       │   │   │   └── service/
│       │   │   │       └── OrderDomainServiceTest.java
│       │   │   ├── delivery/
│       │   │   │   ├── model/
│       │   │   │   │   └── DeliveryTest.java
│       │   │   │   └── service/
│       │   │   │       └── DeliveryDomainServiceTest.java
│       │   │   └── payment/
│       │   │       └── model/
│       │   │           └── PaymentTest.java
│       │   │
│       │   ├── application/
│       │   │   ├── order/
│       │   │   │   └── service/
│       │   │   │       └── OrderApplicationServiceTest.java
│       │   │   ├── delivery/
│       │   │   │   └── service/
│       │   │   │       └── DeliveryApplicationServiceTest.java
│       │   │   └── payment/
│       │   │       └── service/
│       │   │           └── PaymentApplicationServiceTest.java
│       │   │
│       │   ├── infrastructure/
│       │   │   ├── persistence/
│       │   │   │   └── repository/
│       │   │   │       ├── OrderRepositoryImplTest.java
│       │   │   │       └── DeliveryRepositoryImplTest.java
│       │   │   └── geolocation/
│       │   │       └── RouteOptimizationServiceTest.java
│       │   │
│       │   └── interfaces/
│       │       └── rest/
│       │           ├── order/
│       │           │   └── OrderControllerTest.java
│       │           ├── delivery/
│       │           │   └── DeliveryControllerTest.java
│       │           └── payment/
│       │               └── PaymentControllerTest.java
│       │
│       └── resources/
│           ├── application-test.yml
│           └── test-data/
│               ├── orders.json
│               ├── deliveries.json
│               └── payments.json
│
├── pom.xml                                       # Maven Configuration
├── .gitignore
├── README.md
├── ARCHITECTURE.md
├── API_DOCUMENTATION.md
└── docker-compose.yml                            # Docker Services
```

---

## Database Schema

### 1. **users** Table
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('CUSTOMER', 'DRIVER', 'ADMIN', 'SUPPORT') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_password_token VARCHAR(255),
    reset_password_expires_at TIMESTAMP,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_phone (phone_number)
);
```

### 2. **customers** Table
```sql
CREATE TABLE customers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    profile_image_url VARCHAR(500),
    preferred_language VARCHAR(10) DEFAULT 'en',
    loyalty_points INT DEFAULT 0,
    total_orders INT DEFAULT 0,
    total_spent DECIMAL(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

### 3. **addresses** Table
```sql
CREATE TABLE addresses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    address_type ENUM('HOME', 'WORK', 'OTHER') NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    apartment_number VARCHAR(50),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_default BOOLEAN DEFAULT FALSE,
    delivery_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_location (latitude, longitude)
);
```

### 4. **drivers** Table
```sql
CREATE TABLE drivers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    driver_license_number VARCHAR(50) UNIQUE NOT NULL,
    license_expiry_date DATE NOT NULL,
    status ENUM('AVAILABLE', 'BUSY', 'OFFLINE', 'ON_BREAK') DEFAULT 'OFFLINE',
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    total_deliveries INT DEFAULT 0,
    total_ratings INT DEFAULT 0,
    background_check_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    background_check_date DATE,
    date_of_birth DATE NOT NULL,
    profile_image_url VARCHAR(500),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_location (current_latitude, current_longitude),
    INDEX idx_rating (average_rating)
);
```

### 5. **vehicles** Table
```sql
CREATE TABLE vehicles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    driver_id BIGINT NOT NULL,
    vehicle_type ENUM('BIKE', 'SCOOTER', 'CAR', 'VAN', 'TRUCK') NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    color VARCHAR(30),
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    vin VARCHAR(50),
    insurance_policy_number VARCHAR(100),
    insurance_expiry_date DATE NOT NULL,
    registration_expiry_date DATE NOT NULL,
    max_capacity_kg DECIMAL(8, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    INDEX idx_driver_id (driver_id),
    INDEX idx_license_plate (license_plate),
    INDEX idx_vehicle_type (vehicle_type)
);
```

### 6. **orders** Table
```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'PREPARING', 'READY_FOR_PICKUP', 
                'ASSIGNED', 'IN_TRANSIT', 'DELIVERED', 'CANCELLED', 'FAILED') 
                DEFAULT 'PENDING',
    subtotal DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) DEFAULT 0.00,
    delivery_fee DECIMAL(12, 2) DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) DEFAULT 0.00,
    tip_amount DECIMAL(12, 2) DEFAULT 0.00,
    total_amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method ENUM('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI') NOT NULL,
    special_instructions TEXT,
    estimated_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    cancellation_reason TEXT,
    cancelled_by ENUM('CUSTOMER', 'DRIVER', 'ADMIN', 'SYSTEM'),
    cancelled_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

### 7. **order_items** Table
```sql
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_sku VARCHAR(100),
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    weight_kg DECIMAL(8, 2),
    dimensions_cm VARCHAR(50),
    special_handling_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);
```

### 8. **deliveries** Table
```sql
CREATE TABLE deliveries (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    delivery_number VARCHAR(50) UNIQUE NOT NULL,
    order_id BIGINT UNIQUE NOT NULL,
    driver_id BIGINT,
    status ENUM('PENDING', 'ASSIGNED', 'ACCEPTED', 'PICKED_UP', 'IN_TRANSIT', 
                'ARRIVED', 'DELIVERED', 'FAILED', 'CANCELLED') DEFAULT 'PENDING',
    pickup_address_id BIGINT NOT NULL,
    delivery_address_id BIGINT NOT NULL,
    pickup_latitude DECIMAL(10, 8),
    pickup_longitude DECIMAL(11, 8),
    delivery_latitude DECIMAL(10, 8),
    delivery_longitude DECIMAL(11, 8),
    estimated_distance_km DECIMAL(8, 2),
    actual_distance_km DECIMAL(8, 2),
    estimated_duration_minutes INT,
    actual_duration_minutes INT,
    scheduled_pickup_time TIMESTAMP,
    actual_pickup_time TIMESTAMP,
    scheduled_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') DEFAULT 'NORMAL',
    delivery_fee DECIMAL(12, 2),
    driver_earnings DECIMAL(12, 2),
    proof_of_delivery_type ENUM('SIGNATURE', 'PHOTO', 'OTP', 'CONTACTLESS'),
    proof_of_delivery_url VARCHAR(500),
    signature_data TEXT,
    otp_code VARCHAR(10),
    recipient_name VARCHAR(200),
    failure_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE SET NULL,
    FOREIGN KEY (pickup_address_id) REFERENCES addresses(id),
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(id),
    INDEX idx_order_id (order_id),
    INDEX idx_driver_id (driver_id),
    INDEX idx_status (status),
    INDEX idx_delivery_number (delivery_number),
    INDEX idx_scheduled_delivery (scheduled_delivery_time)
);
```

### 9. **delivery_routes** Table
```sql
CREATE TABLE delivery_routes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    delivery_id BIGINT UNIQUE NOT NULL,
    route_data JSON,
    waypoints JSON,
    optimized_route JSON,
    total_distance_km DECIMAL(8, 2),
    estimated_time_minutes INT,
    traffic_factor DECIMAL(3, 2) DEFAULT 1.00,
    weather_conditions VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE,
    INDEX idx_delivery_id (delivery_id)
);
```

### 10. **delivery_tracking** Table
```sql
CREATE TABLE delivery_tracking (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    delivery_id BIGINT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    accuracy_meters DECIMAL(8, 2),
    speed_kmh DECIMAL(8, 2),
    bearing_degrees DECIMAL(5, 2),
    battery_level INT,
    status VARCHAR(50),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE,
    INDEX idx_delivery_id (delivery_id),
    INDEX idx_recorded_at (recorded_at)
);
```

### 11. **payments** Table
```sql
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    payment_number VARCHAR(50) UNIQUE NOT NULL,
    order_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    payment_method ENUM('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI', 'NET_BANKING') NOT NULL,
    payment_gateway VARCHAR(50),
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED') DEFAULT 'PENDING',
    gateway_transaction_id VARCHAR(255),
    gateway_response JSON,
    failure_reason TEXT,
    refund_amount DECIMAL(12, 2),
    refund_reason TEXT,
    refunded_at TIMESTAMP,
    paid_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    INDEX idx_order_id (order_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_payment_number (payment_number),
    INDEX idx_status (status),
    INDEX idx_gateway_transaction (gateway_transaction_id)
);
```

### 12. **payment_transactions** Table
```sql
CREATE TABLE payment_transactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    payment_id BIGINT NOT NULL,
    transaction_type ENUM('CHARGE', 'REFUND', 'CHARGEBACK', 'REVERSAL') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    gateway_reference VARCHAR(255),
    status ENUM('SUCCESS', 'FAILED', 'PENDING') NOT NULL,
    error_code VARCHAR(50),
    error_message TEXT,
    metadata JSON,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE,
    INDEX idx_payment_id (payment_id),
    INDEX idx_transaction_type (transaction_type)
);
```

### 13. **payment_methods** Table
```sql
CREATE TABLE payment_methods (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    method_type ENUM('CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI', 'BANK_ACCOUNT') NOT NULL,
    card_last_four VARCHAR(4),
    card_brand VARCHAR(20),
    card_expiry_month INT,
    card_expiry_year INT,
    cardholder_name VARCHAR(200),
    billing_address JSON,
    gateway_token VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id)
);
```

### 14. **notifications** Table
```sql
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    notification_type ENUM('ORDER_CONFIRMED', 'DELIVERY_ASSIGNED', 'DRIVER_ARRIVED', 
                           'DELIVERY_COMPLETED', 'PAYMENT_SUCCESS', 'PAYMENT_FAILED', 
                           'PROMOTIONAL', 'SYSTEM_ALERT') NOT NULL,
    channel ENUM('EMAIL', 'SMS', 'PUSH', 'IN_APP') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'READ') DEFAULT 'PENDING',
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') DEFAULT 'NORMAL',
    reference_type VARCHAR(50),
    reference_id BIGINT,
    metadata JSON,
    scheduled_at TIMESTAMP,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    failure_reason TEXT,
    retry_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_notification_type (notification_type),
    INDEX idx_scheduled_at (scheduled_at)
);
```

### 15. **notification_preferences** Table
```sql
CREATE TABLE notification_preferences (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNIQUE NOT NULL,
    email_enabled BOOLEAN DEFAULT TRUE,
    sms_enabled BOOLEAN DEFAULT TRUE,
    push_enabled BOOLEAN DEFAULT TRUE,
    in_app_enabled BOOLEAN DEFAULT TRUE,
    order_updates BOOLEAN DEFAULT TRUE,
    promotional_emails BOOLEAN DEFAULT FALSE,
    delivery_tracking BOOLEAN DEFAULT TRUE,
    payment_alerts BOOLEAN DEFAULT TRUE,
    weekly_summary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

### 16. **personal_access_tokens** Table
```sql
CREATE TABLE personal_access_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token_name VARCHAR(100) NOT NULL,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    token_prefix VARCHAR(20) NOT NULL,
    scopes JSON,
    status ENUM('ACTIVE', 'REVOKED', 'EXPIRED') DEFAULT 'ACTIVE',
    last_used_at TIMESTAMP,
    last_used_ip VARCHAR(45),
    expires_at TIMESTAMP,
    revoked_at TIMESTAMP,
    revoked_by BIGINT,
    revocation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_token_hash (token_hash),
    INDEX idx_token_prefix (token_prefix),
    INDEX idx_status (status)
);
```

### 17. **token_permissions** Table
```sql
CREATE TABLE token_permissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    token_id BIGINT NOT NULL,
    permission VARCHAR(100) NOT NULL,
    resource VARCHAR(100),
    action VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (token_id) REFERENCES personal_access_tokens(id) ON DELETE CASCADE,
    INDEX idx_token_id (token_id),
    UNIQUE KEY unique_token_permission (token_id, permission, resource, action)
);
```

### 18. **token_usage_logs** Table
```sql
CREATE TABLE token_usage_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    token_id BIGINT NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    http_method VARCHAR(10) NOT NULL,
    status_code INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    request_payload JSON,
    response_time_ms INT,
    error_message TEXT,
    accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (token_id) REFERENCES personal_access_tokens(id) ON DELETE CASCADE,
    INDEX idx_token_id (token_id),
    INDEX idx_accessed_at (accessed_at)
);
```

### 19. **ratings** Table
```sql
CREATE TABLE ratings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    delivery_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    driver_id BIGINT NOT NULL,
    rating_type ENUM('DRIVER', 'DELIVERY_EXPERIENCE', 'APP_EXPERIENCE') NOT NULL,
    rating_value DECIMAL(2, 1) NOT NULL CHECK (rating_value >= 1.0 AND rating_value <= 5.0),
    review_text TEXT,
    tags JSON,
    is_anonymous BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT TRUE,
    helpful_count INT DEFAULT 0,
    flagged BOOLEAN DEFAULT FALSE,
    flag_reason TEXT,
    response_text TEXT,
    responded_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_driver_id (driver_id),
    INDEX idx_rating_value (rating_value),
    INDEX idx_created_at (created_at)
);
```

### 20. **webhooks** Table
```sql
CREATE TABLE webhooks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    webhook_url VARCHAR(500) NOT NULL,
    secret_key VARCHAR(255) NOT NULL,
    events JSON NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    description TEXT,
    retry_policy JSON,
    last_triggered_at TIMESTAMP,
    success_count INT DEFAULT 0,
    failure_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_active (is_active)
);
```

### 21. **webhook_deliveries** Table
```sql
CREATE TABLE webhook_deliveries (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    webhook_id BIGINT NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSON NOT NULL,
    status ENUM('PENDING', 'SUCCESS', 'FAILED', 'RETRYING') DEFAULT 'PENDING',
    http_status_code INT,
    response_body TEXT,
    error_message TEXT,
    attempt_count INT DEFAULT 0,
    next_retry_at TIMESTAMP,
    delivered_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (webhook_id) REFERENCES webhooks(id) ON DELETE CASCADE,
    INDEX idx_webhook_id (webhook_id),
    INDEX idx_status (status),
    INDEX idx_event_type (event_type),
    INDEX idx_created_at (created_at)
);
```

### 22. **promocodes** Table
```sql
CREATE TABLE promocodes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_DELIVERY') NOT NULL,
    discount_value DECIMAL(12, 2) NOT NULL,
    max_discount_amount DECIMAL(12, 2),
    min_order_amount DECIMAL(12, 2),
    usage_limit INT,
    usage_per_user INT DEFAULT 1,
    current_usage_count INT DEFAULT 0,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    applicable_to ENUM('ALL', 'FIRST_ORDER', 'SPECIFIC_USERS') DEFAULT 'ALL',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_is_active (is_active),
    INDEX idx_valid_dates (valid_from, valid_until)
);
```

### 23. **promocode_usage** Table
```sql
CREATE TABLE promocode_usage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    promocode_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promocode_id) REFERENCES promocodes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_promocode_id (promocode_id),
    INDEX idx_user_id (user_id),
    UNIQUE KEY unique_user_order_promo (user_id, order_id, promocode_id)
);
```

### 24. **audit_logs** Table
```sql
CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT NOT NULL,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_created_at (created_at)
);
```

### 25. **support_tickets** Table
```sql
CREATE TABLE support_tickets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    user_id BIGINT NOT NULL,
    order_id BIGINT,
    delivery_id BIGINT,
    category ENUM('ORDER_ISSUE', 'DELIVERY_ISSUE', 'PAYMENT_ISSUE', 'ACCOUNT', 'TECHNICAL', 'OTHER') NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('OPEN', 'IN_PROGRESS', 'WAITING_ON_CUSTOMER', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN',
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    assigned_to BIGINT,
    resolved_at TIMESTAMP,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_ticket_number (ticket_number),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

---

## Key Benefits of Feature-Based Architecture

1. **High Cohesion**: Related code stays together
2. **Low Coupling**: Features are independent
3. **Easy Testing**: Each feature can be tested in isolation
4. **Clear Ownership**: Teams can own specific features
5. **Faster Development**: New features don't impact existing ones
6. **Better Scalability**: Features can be extracted to microservices
7. **Simplified Navigation**: Easy to find feature-related code
8. **Reduced Merge Conflicts**: Different features rarely touch same files