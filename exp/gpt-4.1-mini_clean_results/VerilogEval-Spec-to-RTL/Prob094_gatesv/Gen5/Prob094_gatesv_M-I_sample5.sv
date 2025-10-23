module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3]=0
    assign out_both = (in & (in << 1)) & 4'b0111;

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0]=0
    assign out_any = (in | (in >> 1)) & 4'b1110;

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // rotate in left by 1 bit for neighbor to the left with wrap-around
    wire [3:0] in_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_rot;

endmodule