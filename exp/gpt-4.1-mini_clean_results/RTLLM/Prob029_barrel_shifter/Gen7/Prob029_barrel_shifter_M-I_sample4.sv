module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Shift by 4 (rotate-left by 4) if ctrl[2] is set
    // Rotate-left by 4 on 8 bits is symmetric to rotate-right by 4
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Shift by 2 (rotate-left by 2) if ctrl[1] is set
    // Rotate-left by 2: bits [7:2] rotate to [5:0], bits [1:0] move to top
    wire [7:0] stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

    // Shift by 1 (rotate-left by 1) if ctrl[0] is set
    // Rotate-left by 1: bit 0 moves to top, bits [7:1] shift right by one
    wire [7:0] stage3 = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

    assign out = stage3;

endmodule