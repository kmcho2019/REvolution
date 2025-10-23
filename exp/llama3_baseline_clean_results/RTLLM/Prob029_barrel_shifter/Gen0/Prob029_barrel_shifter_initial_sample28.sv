module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions
    wire [7:0] shift4_in0, shift4_in1;
    assign shift4_in0 = in;
    assign shift4_in1 = {in[3:0], in[7:4]};
    wire [7:0] shift4_out;
    mux2X1 shift4_mux(in, shift4_in1, ctrl[2], shift4_out);

    // Stage 2: Shift by 2 positions
    wire [7:0] shift2_in0, shift2_in1;
    assign shift2_in0 = shift4_out;
    assign shift2_in1 = {shift4_out[6:0], shift4_out[7]};
    wire [7:0] shift2_out;
    mux2X1 shift2_mux(shift4_out, shift2_in1, ctrl[1], shift2_out);

    // Stage 3: Shift by 1 position
    wire [7:0] shift1_in0, shift1_in1;
    assign shift1_in0 = shift2_out;
    assign shift1_in1 = {shift2_out[6:0], shift2_out[7]};
    mux2X1 shift1_mux(shift2_out, shift1_in1, ctrl[0], out);
endmodule