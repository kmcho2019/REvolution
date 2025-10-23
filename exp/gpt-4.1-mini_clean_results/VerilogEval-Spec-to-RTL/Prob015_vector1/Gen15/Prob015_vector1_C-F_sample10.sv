module ByteSplitter (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Combinational split of input word into two bytes
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);
    // Instantiate fixed-width ByteSplitter for clean hierarchy and optimal PPA
    ByteSplitter splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule