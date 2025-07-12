// mux2X1 submodule
module mux2X1(in0, in1, sel, out);
    input in0, in1, sel;
    output out;
    reg out;

    always @(*)
    begin
        case(sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule

// barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    reg [7:0] out;
    reg [7:0] shifted_by_4, shifted_by_2, shifted_by_1;

    // Generate shifted inputs for each stage
    always @(*)
    begin
        shifted_by_4 = {in[3:0], 4'b0000};
        shifted_by_2 = {in[5:0], 2'b00};
        shifted_by_1 = {in[6:0], 1'b0};
    end

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 m0_0(in[0], shifted_by_4[0], ctrl[2], out[0]);
    mux2X1 m0_1(in[1], shifted_by_4[1], ctrl[2], out[1]);
    mux2X1 m0_2(in[2], shifted_by_4[2], ctrl[2], out[2]);
    mux2X1 m0_3(in[3], shifted_by_4[3], ctrl[2], out[3]);
    mux2X1 m0_4(in[4], shifted_by_4[4], ctrl[2], out[4]);
    mux2X1 m0_5(in[5], shifted_by_4[5], ctrl[2], out[5]);
    mux2X1 m0_6(in[6], shifted_by_4[6], ctrl[2], out[6]);
    mux2X1 m0_7(in[7], shifted_by_4[7], ctrl[2], out[7]);

    // Corrected approach: using intermediate variables for each stage
    reg [7:0] stage1_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 m1_0(in[0], shifted_by_4[0], ctrl[2], stage1_out[0]);
    mux2X1 m1_1(in[1], shifted_by_4[1], ctrl[2], stage1_out[1]);
    mux2X1 m1_2(in[2], shifted_by_4[2], ctrl[2], stage1_out[2]);
    mux2X1 m1_3(in[3], shifted_by_4[3], ctrl[2], stage1_out[3]);
    mux2X1 m1_4(in[4], shifted_by_4[4], ctrl[2], stage1_out[4]);
    mux2X1 m1_5(in[5], shifted_by_4[5], ctrl[2], stage1_out[5]);
    mux2X1 m1_6(in[6], shifted_by_4[6], ctrl[2], stage1_out[6]);
    mux2X1 m1_7(in[7], shifted_by_4[7], ctrl[2], stage1_out[7]);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    reg [7:0] stage2_out;
    mux2X1 m2_0(stage1_out[0], shifted_by_2[0], ctrl[1], stage2_out[0]);
    mux2X1 m2_1(stage1_out[1], shifted_by_2[1], ctrl[1], stage2_out[1]);
    mux2X1 m2_2(stage1_out[2], shifted_by_2[2], ctrl[1], stage2_out[2]);
    mux2X1 m2_3(stage1_out[3], shifted_by_2[3], ctrl[1], stage2_out[3]);
    mux2X1 m2_4(stage1_out[4], shifted_by_2[4], ctrl[1], stage2_out[4]);
    mux2X1 m2_5(stage1_out[5], shifted_by_2[5], ctrl[1], stage2_out[5]);
    mux2X1 m2_6(stage1_out[6], shifted_by_2[6], ctrl[1], stage2_out[6]);
    mux2X1 m2_7(stage1_out[7], shifted_by_2[7], ctrl[1], stage2_out[7]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 m3_0(stage2_out[0], shifted_by_1[0], ctrl[0], out[0]);
    mux2X1 m3_1(stage2_out[1], shifted_by_1[1], ctrl[0], out[1]);
    mux2X1 m3_2(stage2_out[2], shifted_by_1[2], ctrl[0], out[2]);
    mux2X1 m3_3(stage2_out[3], shifted_by_1[3], ctrl[0], out[3]);
    mux2X1 m3_4(stage2_out[4], shifted_by_1[4], ctrl[0], out[4]);
    mux2X1 m3_5(stage2_out[5], shifted_by_1[5], ctrl[0], out[5]);
    mux2X1 m3_6(stage2_out[6], shifted_by_1[6], ctrl[0], out[6]);
    mux2X1 m3_7(stage2_out[7], shifted_by_1[7], ctrl[0], out[7]);
endmodule