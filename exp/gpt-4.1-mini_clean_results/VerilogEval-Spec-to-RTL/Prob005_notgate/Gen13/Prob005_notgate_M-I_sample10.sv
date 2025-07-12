module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for minimal power and area
    assign out = ~in;
endmodule