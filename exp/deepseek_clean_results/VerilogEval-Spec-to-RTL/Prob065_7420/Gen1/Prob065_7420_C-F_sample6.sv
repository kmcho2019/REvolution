module TopModule (
    // First 4-input NAND gate inputs
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    // Second 4-input NAND gate inputs
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    // Outputs
    output p1y,
    output p2y
);

    // First 4-input NAND gate (7420 first gate)
    assign p1y = ~(p1a & p1b & p1c & p1d);
    
    // Second 4-input NAND gate (7420 second gate)
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule