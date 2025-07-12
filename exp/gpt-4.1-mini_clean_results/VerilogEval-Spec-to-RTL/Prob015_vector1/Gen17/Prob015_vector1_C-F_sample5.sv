module ByteSplitter #(
    parameter WIDTH = 16
) (
    input  [WIDTH-1:0] in,
    output [(WIDTH/2)-1:0] out_hi,
    output [(WIDTH/2)-1:0] out_lo
);
    // Direct slicing: upper half and lower half of input bus
    assign out_hi = in[WIDTH-1:WIDTH/2];
    assign out_lo = in[(WIDTH/2)-1:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate ByteSplitter with fixed 16-bit width for current spec
    ByteSplitter #(
        .WIDTH(16)
    ) splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule