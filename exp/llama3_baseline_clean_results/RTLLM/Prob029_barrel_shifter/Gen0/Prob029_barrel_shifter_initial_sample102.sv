module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 mux4_0(in, {in[3:0], 4'b0000}, ctrl[2], shift4[0]);
    mux2X1 mux4_1(in, {in[2:0], in[7:4]}, ctrl[2], shift4[1]);
    mux2X1 mux4_2(in, {in[1:0], in[7:2]}, ctrl[2], shift4[2]);
    mux2X1 mux4_3(in, {in[0], in[7:1]}, ctrl[2], shift4[3]);
    mux2X1 mux4_4(in, {in[7], in[6:0]}, ctrl[2], shift4[4]);
    mux2X1 mux4_5(in, {in[6:0], in[7]}, ctrl[2], shift4[5]);
    mux2X1 mux4_6(in, {in[5:0], in[7:2]}, ctrl[2], shift4[6]);
    mux2X1 mux4_7(in, {in[4:0], in[7:3]}, ctrl[2], shift4[7]);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 mux2_0(shift4, {shift4[6:0], 2'b00}, ctrl[1], shift2[0]);
    mux2X1 mux2_1(shift4, {shift4[5:0], shift4[7:6]}, ctrl[1], shift2[1]);
    mux2X1 mux2_2(shift4, {shift4[4:0], shift4[7:5]}, ctrl[1], shift2[2]);
    mux2X1 mux2_3(shift4, {shift4[3:0], shift4[7:4]}, ctrl[1], shift2[3]);
    mux2X1 mux2_4(shift4, {shift4[2:0], shift4[7:3]}, ctrl[1], shift2[4]);
    mux2X1 mux2_5(shift4, {shift4[1:0], shift4[7:2]}, ctrl[1], shift2[5]);
    mux2X1 mux2_6(shift4, {shift4[0], shift4[7:1]}, ctrl[1], shift2[6]);
    mux2X1 mux2_7(shift4, {shift4[7], shift4[6:0]}, ctrl[1], shift2[7]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 mux1_0(shift2, {shift2[6:0], 1'b0}, ctrl[0], shift1[0]);
    mux2X1 mux1_1(shift2, {shift2[5:0], shift2[7]}, ctrl[0], shift1[1]);
    mux2X1 mux1_2(shift2, {shift2[4:0], shift2[7:5]}, ctrl[0], shift1[2]);
    mux2X1 mux1_3(shift2, {shift2[3:0], shift2[7:4]}, ctrl[0], shift1[3]);
    mux2X1 mux1_4(shift2, {shift2[2:0], shift2[7:3]}, ctrl[0], shift1[4]);
    mux2X1 mux1_5(shift2, {shift2[1:0], shift2[7:2]}, ctrl[0], shift1[5]);
    mux2X1 mux1_6(shift2, {shift2[0], shift2[7:1]}, ctrl[0], shift1[6]);
    mux2X1 mux1_7(shift2, {shift2[7], shift2[6:0]}, ctrl[0], shift1[7]);

    assign out = shift1;
endmodule