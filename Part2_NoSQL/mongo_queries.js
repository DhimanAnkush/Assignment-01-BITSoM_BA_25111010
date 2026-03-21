// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
    { "product_id": "E101", "name": "UltraBook Pro 15", "category": "Electronics", "price": 85000, "specs": { "voltage": "110-240V", "warranty_years": 2 }, "features": ["4K Display"] },
    { "product_id": "C202", "name": "Performance Running Shoes", "category": "Clothing", "attributes": { "size": ["8", "9", "10"], "material": "Polyester" } },
    { "product_id": "G303", "name": "Organic Almond Milk", "category": "Groceries", "price": 350, "expiry_date": ISODate("2024-12-15T00:00:00Z"), "nutrition": { "calories": 60 } }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
    "category": "Electronics",
    "price": { "$gt": 20000 }
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
    "category": "Groceries",
    "expiry_date": { "$lt": ISODate("2025-01-01T00:00:00Z") }
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
    { "product_id": "E101" },
    { "$set": { "discount_percent": 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ "category": 1 });


