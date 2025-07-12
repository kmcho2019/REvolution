module TopModule(
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    assign sum = a ^ b;   // XOR for sum
    assign cout = a & b;  // AND for carry-out

endmodule