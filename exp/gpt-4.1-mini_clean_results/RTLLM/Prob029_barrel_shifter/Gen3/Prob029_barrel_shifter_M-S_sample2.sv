module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Rotate left by ctrl (0 to 7) bits
    assign out = (in << ctrl) | (in >> (8 - ctrl));

endmodule