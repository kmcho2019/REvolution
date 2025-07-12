module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 in_shift4, in, ctrl[2], stage1_out);
    assign in_shift4 = {in[3:0], 4'b0000};

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage1_out, stage1_out_shift2, ctrl[1], stage2_out);
    assign stage1_out_shift2 = {stage1_out[5:0], 2'b00};

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage2_out, stage2_out_shift1, ctrl[0], out);
    assign stage2_out_shift1 = {stage2_out[6:0], 1'b0};
endmodule