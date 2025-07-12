module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Single-stage right rotation by 0-7 positions
    assign out = (in >> ctrl) | (in << (8 - ctrl));
endmodule