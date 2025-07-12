module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

wire [7:0] stage1, stage2;

// Stage 1: Shift by 4 if ctrl[2] is set
assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

// Stage 2: Shift by 2 if ctrl[1] is set
assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

// Stage 3: Shift by 1 if ctrl[0] is set
assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

endmodule