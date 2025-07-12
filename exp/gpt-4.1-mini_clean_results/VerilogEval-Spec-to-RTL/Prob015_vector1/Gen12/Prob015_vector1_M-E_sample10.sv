module BitwiseByteSplitter (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_assign
            assign out_lo[i] = in[i];
            assign out_hi[i] = in[i + 8];
        end
    endgenerate
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the bitwise splitter which connects each output bit explicitly
    BitwiseByteSplitter splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule