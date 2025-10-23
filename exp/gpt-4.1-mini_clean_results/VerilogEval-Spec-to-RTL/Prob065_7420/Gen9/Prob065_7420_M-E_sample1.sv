// TopModule implements two independent 4-input NAND gates of the 7420 chip
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Concatenate inputs for each NAND gate into a 4-bit vector
    wire [3:0] gate1_inputs = {p1a, p1b, p1c, p1d};
    wire [3:0] gate2_inputs = {p2a, p2b, p2c, p2d};

    // Each output is NAND of all 4 inputs (all bits ANDed together, then inverted)
    assign p1y = ~( &gate1_inputs ); // & is reduction AND
    assign p2y = ~( &gate2_inputs );

endmodule