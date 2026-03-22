## 6.2 Design Justification: Hospital AI Data System

## Storage Systems
To meet the four diverse goals of the hospital network, a multi-modal storage strategy was chosen to balance speed, structure, and searchability:

**Predicting Readmission Risk (Analytical Warehouse)**: I chose a Snowflake or Google BigQuery environment. 
Historical treatment data is inherently structured (diagnoses, dates, medications). 
A columnar data warehouse allows the ML models to perform high-speed aggregations 
and feature engineering on years of patient data to identify risk patterns efficiently.

**Plain English Queries (Vector Database)**: For the NLP goal, I integrated a Vector Database (e.g., Pinecone or Chroma). 
Standard SQL struggles with the nuances of "cardiac events." By converting patient histories into high-dimensional embeddings, 
an LLM can perform semantic searches to find relevant medical context instantly.

**Monthly Management Reports (Relational Database/Warehouse)**: The Analytical Data Warehouse also serves this goal. 
Since bed occupancy and costs are quantitative metrics derived from EHR and billing, the "Gold" layer of our Lakehouse provides 
the pre-aggregated tables needed for clean, consistent reporting.

**Real-time Vitals (Time-Series Database)**: I chose InfluxDB or TimescaleDB. ICU monitors generate massive volumes of sequential data. 
A time-series database is optimized for high-write throughput and "eviction policies," allowing us to stream live vitals without slowing down 
the primary clinical databases.

## OLTP vs. OLAP Boundary
The boundary in this design is defined at the Ingestion Layer (ETL/CDC).

The **OLTP (Online Transactional Processing)** side consists of the live Electronic Health Records (EHR) and ICU devices. 
These systems are optimized for "write" operations—recording a single doctor's note or a specific heart rate spike.

The **OLAP (Online Analytical Processing)** side begins once data passes through the Apache Kafka or Airflow pipelines into the Data Warehouse. 
At this point, the data is decoupled from the live hospital environment. This separation is critical: it ensures that a heavy management report 
or a complex AI training job never slows down the actual monitors in the ICU, maintaining a "read-only" environment for the AI and management layers.

## Trade-offs
A significant trade-off in this design is Data Latency vs. System Complexity regarding the "Plain English" query feature.

To provide doctors with the most up-to-date history, the Vector Database needs constant syncing with the EHR. 
We face a choice: implement a complex Real-time RAG (Retrieval-Augmented Generation) pipeline, which is expensive and difficult to maintain, 
or use Batch Syncing, which is simpler but means the AI might "miss" a cardiac event that happened ten minutes ago.

**Mitigation**: I would mitigate this by implementing a Hybrid Search Strategy. The system will use batch processing for the bulk of historical data 
but utilize a smaller, "Hot Cache" or Change Data Capture (CDC) stream for the last 24 hours of patient notes. 
This ensures clinicians see recent critical events without the architectural overhead of re-indexing the entire 10-year patient history every minute.
