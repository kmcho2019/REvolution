module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Combined computation using bitwise operations
    // Each NAND is computed as NOT(AND) of all inputs
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

    /* Alternative implementation showing the LUT concept:
    // 4-input truth table stored as 16-bit LUT mask
    parameter [15:0] NAND4_LUT = 16'hFFFE;
    
    // Compute LUT indices
    wire [3:0] p1_index = {p1a, p1b, p1c, p1d};
    wire [3:0] p2_index = {p2a, p2b, p2c, p2d};
    
    // Outputs from LUT
    assign p1y = NAND4_LUT[p1_index];
    assign p2y = NAND4_LUT[p2_index];
    */

endmodule