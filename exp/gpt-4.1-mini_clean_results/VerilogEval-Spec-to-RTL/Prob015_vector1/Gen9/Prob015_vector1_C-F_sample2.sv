module ByteSplitter #(
    parameter WIDTH = 16,
    parameter HALF = WIDTH/2
) (
    input  [WIDTH-1:0] in,
    output [HALF-1:0]  out_hi,
    output [HALF-1:0]  out_lo
);
    // Direct slicing for combinational splitting without any logic overhead
    assign out_hi = in[WIDTH-1:HALF];
    assign out_lo = in[HALF-1:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate the parameterized splitter specialized for 16 bits
    ByteSplitter #(
        .WIDTH(16),
        .HALF(8)
    ) splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule