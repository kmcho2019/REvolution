`define SPLIT_INPUT(SIG_IN, SIG_OUT_HI, SIG_OUT_LO, WIDTH_IN, WIDTH_OUT) \
    assign SIG_OUT_HI = SIG_IN[(WIDTH_IN - 1) : (WIDTH_IN - WIDTH_OUT)]; \
    assign SIG_OUT_LO = SIG_IN[(WIDTH_OUT - 1) : 0];

module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    `SPLIT_INPUT(in, out_hi, out_lo, 16, 8);

endmodule