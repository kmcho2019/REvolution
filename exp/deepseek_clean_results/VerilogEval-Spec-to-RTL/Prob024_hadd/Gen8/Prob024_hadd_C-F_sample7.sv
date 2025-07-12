// Half Adder Module
// Implements: sum = a XOR b, cout = a AND b
module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Optimal gate-level implementation
    assign sum = a ^ b;   // XOR operation for sum
    assign cout = a & b;  // AND operation for carry-out

endmodule