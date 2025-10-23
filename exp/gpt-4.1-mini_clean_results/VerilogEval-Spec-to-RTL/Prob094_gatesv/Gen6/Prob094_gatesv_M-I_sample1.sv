module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0
    assign out_both = { (in[3] & 1'b0), in[2] & in[3], in[1] & in[2], in[0] & in[1] };

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0
    assign out_any = { in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0 };

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // Explicit indexing for wrap-around
    assign out_different[3] = in[3] ^ in[0];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule