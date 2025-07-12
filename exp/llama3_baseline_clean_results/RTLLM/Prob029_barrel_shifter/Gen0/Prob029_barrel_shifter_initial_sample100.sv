module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;
    
    assign out = (sel) ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    wire [7:0] stage1_out, stage2_out, stage3_out;
    
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 mux0(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 mux1(ctrl[1], stage1_out, {stage1_out[5:0], 2'b00}, stage2_out);
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 mux2(ctrl[0], stage2_out, {stage2_out[6:0], 1'b0}, stage3_out);
    
    assign out = stage3_out;
endmodule