module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3]=0
    // Use shift left by 1 bit to get the "left neighbor"
    assign out_both = (in & (in << 1)) & 4'b0111;  // mask to clear bit 3 (no neighbor)

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0]=0
    // Use shift right by 1 bit to get the "right neighbor"
    assign out_any = (in | (in >> 1)) & 4'b1110;  // mask to clear bit 0 (no neighbor)

    // out_different[i] = in[i] ^ in[(i+1)%4]
    // Create a rotated version of in by 1 bit to the left (wrap around)
    wire [3:0] in_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_rot;

endmodule