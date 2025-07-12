module mux2X1(in1, in2, sel, out);
    input [7:0] in1, in2;
    input sel;
    output [7:0] out;
    
    assign out = (sel == 1'b1) ? in2 : in1;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    wire [7:0] stage1_out, stage2_out, stage3_out;
    
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 in_stage1(in, {in[3:0], in[7:4]}, ctrl[2], stage1_out);
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage1_out, {stage1_out[5:0], stage1_out[7:6]}, ctrl[1], stage2_out);
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], stage3_out);
    
    // Final output
    assign out = stage3_out;
endmodule