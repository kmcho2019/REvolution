module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

    assign sum = a ^ b;     // XOR logic for sum
    assign cout = a & b;    // AND logic for carry-out

endmodule