module ByteSplitter16 #(
    parameter WIDTH = 16  // Parameterize width for future scalability; default 16 bits
)(
    input  [WIDTH-1:0] in,
    output [7:0]       out_hi,
    output [7:0]       out_lo
);
    // Direct slicing: upper byte and lower byte from input vector
    // WIDTH must be at least 16 for correct slicing
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate the parametrized byte splitter module
    ByteSplitter16 #(
        .WIDTH(16)
    ) splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule