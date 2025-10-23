module BitProcessor(
    input  in_bit,
    input  neighbor,
    output out_both,
    output out_any,
    output out_different
);

    assign out_both = in_bit & neighbor;
    assign out_any = in_bit | neighbor;
    assign out_different = in_bit ^ neighbor;

endmodule

module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] shifted_in;

    assign shifted_in[3] = in[0];
    assign shifted_in[2] = in[3];
    assign shifted_in[1] = in[2];
    assign shifted_in[0] = in[1];

    BitProcessor bp0(in[3], 1'b0, out_both[3], out_any[3], out_different[3]);
    BitProcessor bp1(in[2], in[3], out_both[2], out_any[2], out_different[2]);
    BitProcessor bp2(in[1], in[2], out_both[1], out_any[1], out_different[1]);
    BitProcessor bp3(in[0], in[1], out_both[0], out_any[0], out_different[0]);

endmodule