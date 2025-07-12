// 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

// Barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for each stage
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 #(.WIDTH(8)) mux_shift4(in, {in[3:0], 4'b0000}, ctrl[2], shift4);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 #(.WIDTH(8)) mux_shift2(shift4, {shift4[5:0], 2'b00}, ctrl[1], shift2);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 #(.WIDTH(8)) mux_shift1(shift2, {shift2[6:0], 1'b0}, ctrl[0], shift1);

    // Final output is the result of the last stage
    assign out = shift1;
endmodule