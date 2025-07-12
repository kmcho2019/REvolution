// Define the 2-to-1 multiplexer submodule
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

    // Intermediate wires for shifted inputs
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 mux4(ctrl[2], in, {in[3:0], 4'h0}, shift4);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 mux2(ctrl[1], shift4, {shift4[5:0], 2'h0}, shift2);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 mux1(ctrl[0], shift2, {shift2[6:0], 1'h0}, shift1);

    // Output is the result of the final shift
    assign out = shift1;
endmodule