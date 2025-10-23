module ByteSplitter (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Combinational split of input word into two bytes
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate fixed-width ByteSplitter for clean hierarchy and optimal PPA
    ByteSplitter splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule