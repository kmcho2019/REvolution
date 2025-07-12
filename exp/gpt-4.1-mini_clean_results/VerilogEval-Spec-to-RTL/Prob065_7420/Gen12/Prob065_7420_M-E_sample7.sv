// TopModule directly implements two independent 4-input NAND gates equivalent to the 7420 chip
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

    // Intermediate signals for 4-input AND gates
    wire and_p1;
    wire and_p2;

    // Perform 4-input AND for first gate inputs
    assign and_p1 = p1a & p1b & p1c & p1d;

    // Perform 4-input AND for second gate inputs
    assign and_p2 = p2a & p2b & p2c & p2d;

    // NAND outputs by inverting AND results
    assign p1y = ~and_p1;
    assign p2y = ~and_p2;

endmodule