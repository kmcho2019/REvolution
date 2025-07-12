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

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_in0, stage1_in1;
    assign stage1_in0 = in;
    assign stage1_in1 = {in[3:0], in[7:4]};
    wire [7:0] stage1_out;
    mux2X1 mux_stage1(ctrl[2], stage1_in0, stage1_in1, stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_in0, stage2_in1;
    assign stage2_in0 = stage1_out;
    assign stage2_in1 = {stage1_out[1:0], stage1_out[7:2]};
    wire [7:0] stage2_out;
    mux2X1 mux_stage2(ctrl[1], stage2_in0, stage2_in1, stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_in0, stage3_in1;
    assign stage3_in0 = stage2_out;
    assign stage3_in1 = {stage2_out[0], stage2_out[7:1]};
    assign out = (ctrl[0]) ? stage3_in1 : stage3_in0;
endmodule