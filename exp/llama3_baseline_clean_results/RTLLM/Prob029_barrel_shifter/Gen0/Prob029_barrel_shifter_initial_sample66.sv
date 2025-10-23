// Define a 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel == 1'b0) ? in0 : in1;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for shifted inputs
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 in, {in[3:0], in[7:4]}, ctrl[2], shift4;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 shift4, {shift4[5:0], shift4[7:6]}, ctrl[1], shift2;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 shift2, {shift2[6:0], shift2[7]}, ctrl[0], out;
endmodule