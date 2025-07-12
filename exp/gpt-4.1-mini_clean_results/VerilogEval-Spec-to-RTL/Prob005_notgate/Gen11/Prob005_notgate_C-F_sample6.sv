module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for minimal overhead and maximal efficiency
    assign out = ~in;
endmodule