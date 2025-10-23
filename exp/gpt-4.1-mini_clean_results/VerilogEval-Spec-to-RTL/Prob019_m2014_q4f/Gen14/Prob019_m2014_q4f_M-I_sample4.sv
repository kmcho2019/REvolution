module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Combine inversion and AND in one assign statement for minimal gate count and power
    assign out = in1 & ~in2;
endmodule