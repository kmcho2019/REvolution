// 2-to-1 multiplexer submodule
module mux2X1(
    input  [7:0] in0, in1,
    input        sel,
    output [7:0] out
);

    assign out = (sel) ? in1 : in0;

endmodule

// Barrel shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    assign shift4 = {in[3:0], 4'b0000};

    // Shift by 2 positions
    assign shift2 = {in[5:0], 2'b00};

    // Shift by 1 position
    assign shift1 = {in[6:0], 1'b0};

    // Perform the shifts in stages
    mux2X1 stage1(in, shift4, ctrl[2], shift2);
    mux2X1 stage2(shift2, shift1, ctrl[1], shift1);
    mux2X1 stage3(shift1, {shift1[6:0], shift1[7]}, ctrl[0], out);

endmodule