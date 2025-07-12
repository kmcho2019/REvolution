/*
 * TopModule - Hierarchical NOR Gate Implementation
 * 
 * Functionality:
 * Implements NOR operation using NAND gates (universal gate approach)
 * out = ~(a | b) = ~a & ~b (De Morgan's transformation)
 * 
 * Advantages:
 * - May offer better PPA in technologies where NAND gates are more optimized
 * - Demonstrates universal gate implementation
 * - Clear documentation of logical transformation
 * 
 * Implementation:
 * 1. Invert input a
 * 2. Invert input b
 * 3. NAND the inverted signals
 * 
 * Truth Table:
 * a b | ~a ~b | NAND(~a,~b) | out
 * --------------------------------
 * 0 0 | 1  1  |     0       | 1
 * 0 1 | 1  0  |     1       | 0
 * 1 0 | 0  1  |     1       | 0
 * 1 1 | 0  0  |     1       | 0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    wire a_inv, b_inv;
    
    // Step 1: Invert inputs
    assign a_inv = ~a;
    assign b_inv = ~b;
    
    // Step 2: NAND the inverted signals
    assign out = ~(a_inv & b_inv);
endmodule