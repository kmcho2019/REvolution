// Define the submodule mux2X1
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel)? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions
    mux2X1 mux_shift4(ctrl[2], in, {in[3:0], 4'd0}, shift4);

    // Stage 2: Shift by 2 positions
    mux2X1 mux_shift2(ctrl[1], shift4, {shift4[5:0], 2'd0}, shift2);

    // Stage 3: Shift by 1 position
    mux2X1 mux_shift1(ctrl[0], shift2, {shift2[6:0], 1'd0}, shift1);

    // Output the final shifted result
    assign out = shift1;
endmodule