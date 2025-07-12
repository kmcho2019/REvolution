module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

// Stage 1: Select between inputs based on the least significant bit of sel
wire [15:0] stage1_out0, stage1_out1, stage1_out2, stage1_out3;
assign stage1_out0 = (sel[0] == 0)? a : b;
assign stage1_out1 = (sel[0] == 0)? c : d;
assign stage1_out2 = (sel[0] == 0)? e : f;
assign stage1_out3 = (sel[0] == 0)? g : h;

// Stage 2: Select based on the next bit of sel
wire [15:0] stage2_out0, stage2_out1;
assign stage2_out0 = (sel[1] == 0)? stage1_out0 : stage1_out1;
assign stage2_out1 = (sel[1] == 0)? stage1_out2 : stage1_out3;

// Additional input for handling sel > 8
wire [15:0] const_ones = 16'b1111111111111111;

// Stage 3: Select based on the next bit of sel and include const_ones for sel > 8
wire [15:0] stage3_out0;
assign stage3_out0 = (sel[2] == 0)? stage2_out0 : (sel[2:1] == 2'b10)? i : stage2_out1;

// Stage 4: Final selection based on the most significant bit of sel
assign out = (sel[3] == 0)? stage3_out0 : const_ones;

endmodule