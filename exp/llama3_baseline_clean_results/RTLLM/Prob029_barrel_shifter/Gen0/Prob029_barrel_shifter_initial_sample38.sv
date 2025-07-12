module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel)? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] shift4;
    mux2X1 #(.WIDTH(8)) mux_shift4(ctrl[2], in, {in[3:0], 4'b0000}, shift4);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] shift2;
    mux2X1 #(.WIDTH(8)) mux_shift2(ctrl[1], shift4, {shift4[5:0], 2'b00}, shift2);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] shift1;
    mux2X1 #(.WIDTH(8)) mux_shift1(ctrl[0], shift2, {shift2[6:0], 1'b0}, shift1);

    assign out = shift1;
endmodule