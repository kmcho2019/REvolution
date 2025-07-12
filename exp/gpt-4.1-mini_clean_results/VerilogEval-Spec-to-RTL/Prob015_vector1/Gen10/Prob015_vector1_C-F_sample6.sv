module ByteSplitter #(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 8
) (
    input  [IN_WIDTH-1:0] in,
    output [OUT_WIDTH-1:0] out_hi,
    output [OUT_WIDTH-1:0] out_lo
);
    // Direct slicing for combinational output split
    assign out_hi = in[IN_WIDTH-1:IN_WIDTH-OUT_WIDTH];
    assign out_lo = in[OUT_WIDTH-1:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Instantiate generic byte splitter specialized for 16-bit input
    ByteSplitter #(
        .IN_WIDTH(16),
        .OUT_WIDTH(8)
    ) splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule