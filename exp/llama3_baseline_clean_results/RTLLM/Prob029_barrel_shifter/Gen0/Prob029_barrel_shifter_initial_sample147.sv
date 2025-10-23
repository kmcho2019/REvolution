// Define the mux2X1 submodule
module mux2X1(in0, in1, sel, out);
  input [7:0] in0, in1;
  input sel;
  output [7:0] out;

  assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
  input [7:0] in;
  input [2:0] ctrl;
  output [7:0] out;

  // Stage 1: Shift by 4 positions if ctrl[2] is high
  wire [7:0] stage1_out;
  mux2X1 u_stage1(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out);

  // Stage 2: Shift by 2 positions if ctrl[1] is high
  wire [7:0] stage2_out;
  mux2X1 u_stage2(stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1], stage2_out);

  // Stage 3: Shift by 1 position if ctrl[0] is high
  mux2X1 u_stage3(stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0], out);
endmodule