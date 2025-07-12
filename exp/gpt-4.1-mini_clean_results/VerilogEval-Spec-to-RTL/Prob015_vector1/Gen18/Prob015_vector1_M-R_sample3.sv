module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Direct continuous assignment of slices without a submodule
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule