module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Intermediate combinational signals
    wire or_ab; // OR of inputs a and b
    wire or_cd; // OR of inputs c and d

    // Compute OR of a and b
    assign or_ab = a | b;

    // Compute OR of c and d
    assign or_cd = c | d;

    // Final output q is AND of the two OR results
    assign q = or_ab & or_cd;

endmodule