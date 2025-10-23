module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    assign sum = a ^ b;  // Direct XOR implementation for optimal performance
    assign cout = a & b; // Standard AND for carry-out

endmodule