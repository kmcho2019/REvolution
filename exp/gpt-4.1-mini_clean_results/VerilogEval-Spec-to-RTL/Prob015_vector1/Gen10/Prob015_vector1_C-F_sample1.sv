module ByteSplitter #(
    parameter IN_WIDTH = 16,
    parameter BYTE_WIDTH = 8
) (
    input  [IN_WIDTH-1:0] in,
    output [BYTE_WIDTH-1:0] out_hi,
    output [BYTE_WIDTH-1:0] out_lo
);
    // Direct slicing of high and low bytes without added logic
    assign out_hi = in[IN_WIDTH-1:IN_WIDTH-BYTE_WIDTH];
    assign out_lo = in[BYTE_WIDTH-1:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate the parameterized ByteSplitter specialized for 16-bit input and 8-bit bytes
    ByteSplitter #(
        .IN_WIDTH(16),
        .BYTE_WIDTH(8)
    ) splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule