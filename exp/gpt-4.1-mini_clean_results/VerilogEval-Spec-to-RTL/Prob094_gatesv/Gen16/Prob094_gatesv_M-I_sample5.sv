module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0
    // Use vector operation: out_both[2:0] = in[2:0] & in[3:1]
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0
    // Use vector operation: out_any[3:1] = in[3:1] | in[2:0]
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 4], wrap-around
    assign out_different[3:0] = in ^ {in[2:0], in[3]};

endmodule