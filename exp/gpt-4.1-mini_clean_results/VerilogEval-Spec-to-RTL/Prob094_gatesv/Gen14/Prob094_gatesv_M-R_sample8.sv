module TopModule(
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3]=0 (no left neighbor)
    // Use shift-left by 1 to align neighbors, MSB has no neighbor -> zero
    assign out_both = (in & (in << 1)) & 4'b0111;

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0]=0 (no right neighbor)
    // Use shift-right by 1 for right neighbors, LSB zeroed
    assign out_any = (in | (in >> 1)) & 4'b1110;

    // out_different[i] = in[i] ^ in[left neighbor], with wrap-around
    // left neighbor of i is (i+1)%4, implement by rotating left by 1 bit
    wire [3:0] rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ rotated_left;

endmodule