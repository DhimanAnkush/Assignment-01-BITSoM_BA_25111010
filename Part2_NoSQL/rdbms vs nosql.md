
[rdbms_vs_nosql.md](https://github.com/user-attachments/files/26158473/rdbms_vs_nosql.md)

## Database Recommendation

For a core patient management system, MySQL is the superior recommendation. Healthcare systems handle highly sensitive, structured data—such as medical history, prescriptions, and billing—where data integrity is non-negotiable.

**ACID vs. BASE**: Patient data requires strict ACID (Atomicity, Consistency, Isolation, Durability) properties. If a doctor prescribes a medication, the record must be immediately consistent across all views to prevent life-threatening dosing errors. MySQL’s relational model ensures that relationships (e.g., a Patient ID linked to multiple Lab Results) remain valid via foreign keys. Conversely, MongoDB follows a BASE philosophy, prioritizing "Eventual Consistency." In a clinical setting, "eventual" consistency is unacceptable; a delayed update to a patient's allergy list could lead to a fatal medical mistake.

**CAP Theorem**: Under the CAP Theorem, MySQL typically leans towards CA (Consistency and Availability), ensuring that every read receives the most recent write. While MongoDB is CP (Consistency and Partition Tolerance), maintaining strict consistency in a distributed NoSQL environment can be more complex than in a mature RDBMS.

**The Fraud Detection Shift**:
If the startup needs to add a fraud detection module, my recommendation would shift toward a Polyglot Persistence approach. While the core patient records should remain in MySQL for safety, the fraud detection module would benefit from MongoDB. Fraud detection requires processing high-velocity, semi-structured data (access logs, IP addresses, login patterns, and device fingerprints) to identify anomalies in real-time. MongoDB’s dynamic schema and horizontal scalability make it far better suited for this high-throughput analytical task than a rigid relational table. Using both allows the system to be "Secure for Records" and "Fast for Detection."

