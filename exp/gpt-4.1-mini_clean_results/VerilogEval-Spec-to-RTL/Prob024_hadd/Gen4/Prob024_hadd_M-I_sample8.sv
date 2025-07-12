module TopModule(
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    // Half adder logic:
    // sum is XOR of inputs
    assign sum = a ^ b;

    // cout (carry out) is AND of inputs
    assign cout = a & b;

endmodule