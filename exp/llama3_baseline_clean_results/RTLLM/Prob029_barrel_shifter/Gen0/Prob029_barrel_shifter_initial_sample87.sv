module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Define intermediate signals
    wire [7:0] shift4, shift2, shift1;

    // First stage: Shift by 4 positions
    mux2X1 mux4(ctrl[2], in, {in[3:0], 4'b0000}, shift4);

    // Second stage: Shift by 2 positions
    mux2X1 mux2(ctrl[1], shift4, {shift4[5:0], 2'b00}, shift2);

    // Third stage: Shift by 1 position
    mux2X1 mux1(ctrl[0], shift2, {shift2[6:0], 1'b0}, shift1);

    // Assign final output
    assign out = shift1;
endmodule