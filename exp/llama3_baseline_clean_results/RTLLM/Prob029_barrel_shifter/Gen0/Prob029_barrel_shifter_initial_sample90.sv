module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;
    
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    wire [7:0] stage1_out;
    
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux0(in, {in[3:0], 4'd0}, ctrl[2], stage1_out[0]);
    mux2X1 stage1_mux1(in, {in[2:0], 4'd0, in[7]}, ctrl[2], stage1_out[1]);
    mux2X1 stage1_mux2(in, {in[1:0], 5'd0, in[7:6]}, ctrl[2], stage1_out[2]);
    mux2X1 stage1_mux3(in, {in[0], 6'd0, in[7:5]}, ctrl[2], stage1_out[3]);
    mux2X1 stage1_mux4(in, {7'd0, in[7]}, ctrl[2], stage1_out[4]);
    mux2X1 stage1_mux5(in, {6'd0, in[7:2]}, ctrl[2], stage1_out[5]);
    mux2X1 stage1_mux6(in, {5'd0, in[7:3]}, ctrl[2], stage1_out[6]);
    mux2X1 stage1_mux7(in, {4'd0, in[7:4]}, ctrl[2], stage1_out[7]);
    
    wire [7:0] stage2_out;
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux0(stage1_out, {stage1_out[5:0], 2'd0}, ctrl[1], stage2_out[0]);
    mux2X1 stage2_mux1(stage1_out, {stage1_out[4:0], 3'd0, stage1_out[7]}, ctrl[1], stage2_out[1]);
    mux2X1 stage2_mux2(stage1_out, {stage1_out[3:0], 4'd0, stage1_out[7:6]}, ctrl[1], stage2_out[2]);
    mux2X1 stage2_mux3(stage1_out, {stage1_out[2:0], 5'd0, stage1_out[7:5]}, ctrl[1], stage2_out[3]);
    mux2X1 stage2_mux4(stage1_out, {stage1_out[1:0], 6'd0, stage1_out[7:4]}, ctrl[1], stage2_out[4]);
    mux2X1 stage2_mux5(stage1_out, {stage1_out[0], 7'd0, stage1_out[7:3]}, ctrl[1], stage2_out[5]);
    mux2X1 stage2_mux6(stage1_out, {8'd0, stage1_out[7:2]}, ctrl[1], stage2_out[6]);
    mux2X1 stage2_mux7(stage1_out, {7'd0, stage1_out[7:1]}, ctrl[1], stage2_out[7]);
    
    wire [7:0] stage3_out;
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux0(stage2_out, {stage2_out[6:0], 1'd0}, ctrl[0], stage3_out[0]);
    mux2X1 stage3_mux1(stage2_out, {stage2_out[5:0], 2'd0, stage2_out[7]}, ctrl[0], stage3_out[1]);
    mux2X1 stage3_mux2(stage2_out, {stage2_out[4:0], 3'd0, stage2_out[7:6]}, ctrl[0], stage3_out[2]);
    mux2X1 stage3_mux3(stage2_out, {stage2_out[3:0], 4'd0, stage2_out[7:5]}, ctrl[0], stage3_out[3]);
    mux2X1 stage3_mux4(stage2_out, {stage2_out[2:0], 5'd0, stage2_out[7:4]}, ctrl[0], stage3_out[4]);
    mux2X1 stage3_mux5(stage2_out, {stage2_out[1:0], 6'd0, stage2_out[7:3]}, ctrl[0], stage3_out[5]);
    mux2X1 stage3_mux6(stage2_out, {stage2_out[0], 7'd0, stage2_out[7:2]}, ctrl[0], stage3_out[6]);
    mux2X1 stage3_mux7(stage2_out, {8'd0, stage2_out[7:1]}, ctrl[0], stage3_out[7]);
    
    assign out = stage3_out;
endmodule