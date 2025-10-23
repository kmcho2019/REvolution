module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] shift_4;
    wire [7:0] shift_2;
    wire [7:0] shift_1;

    // Shift by 4 positions if ctrl[2] is high
    assign shift_4 = (ctrl[2]) ? {in[3:0], in[7:4]} : in;

    // Shift by 2 positions if ctrl[1] is high
    assign shift_2 = (ctrl[1]) ? {shift_4[5:0], shift_4[7:6]} : shift_4;

    // Shift by 1 position if ctrl[0] is high
    assign shift_1 = (ctrl[0]) ? {shift_2[6:0], shift_2[7]} : shift_2;

    // Final output
    assign out = shift_1;

endmodule