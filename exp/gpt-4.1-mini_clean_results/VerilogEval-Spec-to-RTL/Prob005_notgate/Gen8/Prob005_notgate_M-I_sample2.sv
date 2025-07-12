module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for inversion
    assign out = ~in;
endmodule