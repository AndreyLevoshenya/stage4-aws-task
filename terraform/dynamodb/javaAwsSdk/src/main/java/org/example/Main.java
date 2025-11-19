package org.example;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.BatchGetItemRequest;
import software.amazon.awssdk.services.dynamodb.model.BatchGetItemResponse;
import software.amazon.awssdk.services.dynamodb.model.KeysAndAttributes;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Main {
    public static void main(String[] args) {
        try (DynamoDbClient client = DynamoDbClient.builder().endpointOverride(URI.create("http://localhost:4566"))
                .region(Region.EU_CENTRAL_1).build()) {

            String tableName = "MJC-Andrey_Levoshenya-Fleet";

            List<Map<String, AttributeValue>> keys = new ArrayList<>();

            String ussEnterprise = "USS Enterprise";
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701-B").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701-C").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701-D").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701-E").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));
            keys.add(Map.of(
                    "registry", AttributeValue.builder().s("NCC-1701-F").build(),
                    "name", AttributeValue.builder().s(ussEnterprise).build()
            ));

            KeysAndAttributes keysAndAttributes = KeysAndAttributes.builder().keys(keys).build();

            Map<String, KeysAndAttributes> request = Map.of(tableName, keysAndAttributes);

            BatchGetItemRequest batchGetItemRequest = BatchGetItemRequest.builder().requestItems(request).build();

            BatchGetItemResponse batchGetItemResponse = client.batchGetItem(batchGetItemRequest);

            batchGetItemResponse.responses().get(tableName).forEach(System.out::println);

            if (!batchGetItemResponse.unprocessedKeys().isEmpty()) {
                System.out.println("Unprocessed keys: " + batchGetItemResponse.unprocessedKeys());
            }
        }
    }
}