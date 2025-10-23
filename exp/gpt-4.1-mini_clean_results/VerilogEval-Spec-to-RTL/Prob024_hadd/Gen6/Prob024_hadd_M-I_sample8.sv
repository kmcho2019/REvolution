module TopModule(
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    // Sum is XOR of inputs
    assign sum = a ^ b;
    // Carry-out is AND of inputs
    assign cout = a & b;

endmodule