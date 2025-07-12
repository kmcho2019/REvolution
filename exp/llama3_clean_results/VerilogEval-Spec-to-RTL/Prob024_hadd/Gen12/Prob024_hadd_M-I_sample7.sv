module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    // The existing implementation is already optimized for the half adder logic
    assign sum = a ^ b; // XOR operation to calculate the sum
    assign cout = a & b; // AND operation to calculate the carry-out

endmodule