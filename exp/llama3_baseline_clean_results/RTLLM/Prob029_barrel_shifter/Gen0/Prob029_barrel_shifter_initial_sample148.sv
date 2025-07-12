module mux2X1(in1, in2, sel, out);
    input [7:0] in1, in2;
    input sel;
    output [7:0] out;

    assign out = sel ? in2 : in1;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    mux2X1 in_shift4(in, {in[3:0], 4'b0000}, ctrl[2], shift4);

    // Shift by 2 positions
    mux2X1 shift4_shift2(shift4, {shift4[5:0], 2'b00}, ctrl[1], shift2);

    // Shift by 1 position
    mux2X1 shift2_shift1(shift2, {shift2[6:0], 1'b0}, ctrl[0], shift1);

    assign out = shift1;
endmodule