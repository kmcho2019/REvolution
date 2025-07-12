// 2-to-1 Multiplexer module
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

// Barrel Shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate signals for each stage
    wire [7:0] shifted_by_4, shifted_by_2, shifted_by_1;

    // Stage 1: Shift by 4 positions
    mux2X1 mux_by_4(ctrl[2], in, {in[3:0], 4'b0000}, shifted_by_4);

    // Stage 2: Shift by 2 positions
    mux2X1 mux_by_2(ctrl[1], shifted_by_4, {shifted_by_4[5:0], 2'b00}, shifted_by_2);

    // Stage 3: Shift by 1 position
    mux2X1 mux_by_1(ctrl[0], shifted_by_2, {shifted_by_2[6:0], 1'b0}, shifted_by_1);

    // Final output
    assign out = shifted_by_1;
endmodule