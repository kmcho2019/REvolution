// Define the mux2X1 submodule
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Internal signals for the shifted inputs
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions if ctrl[2] is high
    mux2X1 u1(ctrl[2], in, {in[3:0], in[7:4]}, shift4);

    // Shift by 2 positions if ctrl[1] is high
    mux2X1 u2(ctrl[1], shift4, {shift4[5:0], shift4[7:6]}, shift2);

    // Shift by 1 position if ctrl[0] is high
    mux2X1 u3(ctrl[0], shift2, {shift2[6:0], shift2[7]}, shift1);

    // The final output is the result of the last shift
    assign out = shift1;
endmodule