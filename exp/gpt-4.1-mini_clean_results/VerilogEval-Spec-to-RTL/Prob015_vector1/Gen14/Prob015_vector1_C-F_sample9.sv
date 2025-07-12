module ByteSplitter (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Directly assign upper and lower bytes from input
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Instantiate ByteSplitter with fixed widths, no parameters, for minimal overhead
    ByteSplitter splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule