// Define the mux2X1 submodule for 2-to-1 multiplexing
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = sel ? b : a;
endmodule

// Main barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for shifts
    wire [7:0] shift4, shift2, shift1;

    // Instantiate mux2X1 for each bit position for shift by 4
    mux2X1 shift4_mux(in, {in[3:0], in[7:4]}, ctrl[2], shift4);

    // Instantiate mux2X1 for each bit position for shift by 2
    mux2X1 shift2_mux(shift4, {shift4[5:0], shift4[7:6]}, ctrl[1], shift2);

    // Instantiate mux2X1 for each bit position for shift by 1
    mux2X1 shift1_mux(shift2, {shift2[6:0], shift2[7]}, ctrl[0], out);
endmodule