module TopModule (
    input  wire in,
    output wire out
);
    // Minimal combinational logic: direct inversion using continuous assignment
    assign out = ~in;
endmodule