module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for inversion reduces area and power
    assign out = ~in;
endmodule