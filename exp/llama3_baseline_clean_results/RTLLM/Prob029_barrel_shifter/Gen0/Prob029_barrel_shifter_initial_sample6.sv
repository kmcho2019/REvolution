// 2-to-1 Multiplexer Module
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

// Barrel Shifter Module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    wire [7:0] stage1_in0 = in;
    wire [7:0] stage1_in1 = {in[3:0], 4'd0}; // Shift in by 4 positions
    mux2X1 stage1_mux(ctrl[2], stage1_in0, stage1_in1, stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    wire [7:0] stage2_in0 = stage1_out;
    wire [7:0] stage2_in1 = {stage1_out[5:0], 2'd0}; // Shift stage1_out by 2 positions
    mux2X1 stage2_mux(ctrl[1], stage2_in0, stage2_in1, stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    wire [7:0] stage3_in0 = stage2_out;
    wire [7:0] stage3_in1 = {stage2_out[6:0], 1'd0}; // Shift stage2_out by 1 position
    mux2X1 stage3_mux(ctrl[0], stage3_in0, stage3_in1, stage3_out);

    // Final output
    assign out = stage3_out;
endmodule