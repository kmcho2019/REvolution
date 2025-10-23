module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;
    
    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    wire [7:0] stage1_out, stage2_out;
    
    // First stage: Shift by 4 positions if ctrl[2] is high
    mux2X1 mux_stage1(ctrl[2], in, {in[3:0], in[7:4]}, stage1_out);
    
    // Second stage: Shift by 2 positions if ctrl[1] is high
    mux2X1 mux_stage2(ctrl[1], stage1_out, {stage1_out[6:0], stage1_out[7:7]}, stage2_out);
    
    // Third stage: Shift by 1 position if ctrl[0] is high
    mux2X1 mux_stage3(ctrl[0], stage2_out, {stage2_out[6:0], stage2_out[7]}, out);
endmodule