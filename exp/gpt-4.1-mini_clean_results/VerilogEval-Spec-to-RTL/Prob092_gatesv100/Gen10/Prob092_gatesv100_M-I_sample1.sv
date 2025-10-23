module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// out_both[i] = in[i] & in[i+1] for i=0..98
// out_both[99] = 0 (no neighbor to the left)
assign out_both[99] = 1'b0;
assign out_both[98:0] = in[98:0] & in[99:1];

// out_any[i] = in[i] | in[i-1] for i=1..99
// out_any[0] = 0 (no neighbor to the right)
// Implemented as: out_any = in | (in shifted right by 1 bit with zero fill)
assign out_any[0] = 1'b0;
assign out_any[99:1] = in[99:1] | in[98:0];

// out_different[i] = in[i] ^ in[left neighbor]
// left neighbor wraps around:
// left neighbor of i = (i+1) mod 100
// Implement rotation of in left by 1 bit for neighbor vector
wire [99:0] in_rot_left1;
assign in_rot_left1 = {in[98:0], in[99]}; // left rotate by 1 bit (MSB moves to LSB)

// XOR with rotated vector
assign out_different = in ^ in_rot_left1;

endmodule