module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // XOR-based implementation (equivalent to the MUX version)
    assign sum = a ^ b;       // Explicit XOR operation for sum
    assign cout = a & b;      // AND operation for carry remains the same
endmodule