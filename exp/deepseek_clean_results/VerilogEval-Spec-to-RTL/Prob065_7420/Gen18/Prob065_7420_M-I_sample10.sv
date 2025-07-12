module TopModule (
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
    // First 4-input NAND gate implementation
    wire p1_and = p1a & p1b & p1c & p1d;
    assign p1y = ~p1_and;

    // Second 4-input NAND gate implementation
    wire p2_and = p2a & p2b & p2c & p2d;
    assign p2y = ~p2_and;
endmodule