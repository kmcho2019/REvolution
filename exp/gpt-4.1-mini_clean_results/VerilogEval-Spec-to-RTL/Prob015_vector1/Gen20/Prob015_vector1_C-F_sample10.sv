module ByteSplitter (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Direct slicing: assign high and low bytes of input
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Modular instantiation of ByteSplitter for clarity and reuse
    ByteSplitter splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule