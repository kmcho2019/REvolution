module ByteSplitter #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] in,
    output wire [7:0]       out_hi,
    output wire [7:0]       out_lo
);
    // Assert WIDTH is at least 16 to safely slice bytes
    // Slicing upper byte: bits [15:8], lower byte: bits [7:0]
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);

    // Instantiate ByteSplitter with default WIDTH=16
    ByteSplitter splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule