module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    wire bit0_sel = in[0];
    wire bit1_sel = in[1] & ~in[0];
    wire bit2_sel = in[2] & ~in[1] & ~in[0];
    wire bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    assign pos = bit0_sel ? 2'd0 :
                 bit1_sel ? 2'd1 :
                 bit2_sel ? 2'd2 :
                 bit3_sel ? 2'd3 :
                 2'd0;
endmodule