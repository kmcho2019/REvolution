module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;
    
    always @(*)
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = 8'b0;
        endcase
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    wire [7:0] stage1_out, stage2_out;
    
    // Stage 1: Shift by 4 positions
    mux2X1 mux1(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);
    
    // Stage 2: Shift by 2 positions
    mux2X1 mux2(ctrl[1], stage1_out, {stage1_out[1:0], 6'b000000}, stage2_out);
    
    // Stage 3: Shift by 1 position
    mux2X1 mux3(ctrl[0], stage2_out, {stage2_out[0], 7'b0000000}, out);
endmodule