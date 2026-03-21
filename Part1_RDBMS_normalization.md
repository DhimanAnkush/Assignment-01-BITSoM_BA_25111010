1.1
Anomaly Analysis

Insert Anomaly: We cannot add a new Product to the system (e.g., a "Webcam" with product_id P010) until someone actually places an order for it. 
Since order_id is the primary record key, storing a product without an order would require null values or dummy data in order-related columns.

Update Anomaly: Priya Sharma (C002) appears in multiple rows (e.g., Row 0 and Row 3). 
If she changes her email address, we must update it in every single row where she has an order. 
If Row 0 is updated but Row 3 is missed, the database will contain conflicting information for the same customer.

Delete Anomaly: If Vikram Singh (C005) has only one order in the system (e.g., ORD1075 in Row 7) 
and that order is deleted due to a cancellation, we lose all information about Vikram (his email and city) as well.
