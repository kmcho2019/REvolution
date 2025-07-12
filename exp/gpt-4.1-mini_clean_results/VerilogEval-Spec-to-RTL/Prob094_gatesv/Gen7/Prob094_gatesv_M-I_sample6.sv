module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[0:2] = in[0:2] & in[1:3], out_both[3] = 0
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any[1:3] = in[1:3] | in[0:2], out_any[0] = 0
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 4] (rotate left by 1)
    assign out_different = in ^ {in[2:0], in[3]};

endmodule