// Define the mux2X1 submodule
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel)? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Internal wires for shifted inputs
    wire [7:0] shift_4, shift_2, shift_1;

    // Shift by 4 positions if ctrl[2] is high
    assign shift_4 = (ctrl[2])? {in[3:0], 4'b0000} : in;

    // Shift by 2 positions if ctrl[1] is high
    assign shift_2 = (ctrl[1])? {shift_4[5:0], 2'b00} : shift_4;

    // Shift by 1 position if ctrl[0] is high
    assign shift_1 = (ctrl[0])? {shift_2[6:0], 1'b0} : shift_2;

    // Final output is the result of all shifts
    assign out = shift_1;
endmodule

// Alternatively, you can implement the barrel_shifter using mux2X1 submodules
module barrel_shifter_mux(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Internal wires for intermediate results
    wire [7:0] shift_4, shift_2, shift_1;

    // Stage 1: Shift by 4 positions
    mux2X1 mux_shift_4(ctrl[2], in, {in[3:0], 4'b0000}, shift_4);

    // Stage 2: Shift by 2 positions
    mux2X1 mux_shift_2(ctrl[1], shift_4, {shift_4[5:0], 2'b00}, shift_2);

    // Stage 3: Shift by 1 position
    mux2X1 mux_shift_1(ctrl[0], shift_2, {shift_2[6:0], 1'b0}, shift_1);

    // Final output is the result of all shifts
    assign out = shift_1;
endmodule