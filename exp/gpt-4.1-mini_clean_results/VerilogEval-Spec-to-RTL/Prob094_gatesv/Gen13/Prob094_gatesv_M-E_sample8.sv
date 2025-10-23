module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3] = 0 (no left neighbor)
    assign out_both = {3{1'b0}} | {in[3], in[2] & in[3], in[1] & in[2], in[0] & in[1]};
    // Explanation: build bits in order from MSB=bit 3 down to LSB=bit 0
    // But this needs correction as out_both[3] = 0, out_both[2] = in[2]&in[3], etc.

    // Correct explicit assignment for out_both bits:
    // bit3: no neighbor -> 0
    // bit2: in[2] & in[3]
    // bit1: in[1] & in[2]
    // bit0: in[0] & in[1]
    assign out_both = {1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0] = 0 (no right neighbor)
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // Implement by XOR of in with a left-rotated version of in by 1
    wire [3:0] in_rot_left1 = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left1;

endmodule