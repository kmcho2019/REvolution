module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    assign sum = a ^ b;  // XOR operation for sum bit
    assign cout = a & b; // AND operation for carry-out

endmodule