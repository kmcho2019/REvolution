module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Rotate right by ctrl bits (0-7 positions)
    assign out = {in, in} >> ctrl;

endmodule