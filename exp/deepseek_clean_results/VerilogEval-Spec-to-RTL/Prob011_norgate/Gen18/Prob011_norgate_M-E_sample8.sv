/*
 * TopModule - NOR Gate Implemented with NAND Gates
 * 
 * Functionality:
 * Implements NOR operation using only NAND gates (universal gate implementation)
 * out = ~(a | b) = ~a & ~b = NAND(NAND(a,a), NAND(b,b))
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 * 
 * Gate-Level Implementation:
 * 1. NAND(a,a) -> ~a
 * 2. NAND(b,b) -> ~b
 * 3. NAND(~a, ~b) -> ~(~a & ~b) = a | b
 * 4. NAND(result, result) -> ~(a | b)
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    wire not_a, not_b;
    wire or_ab;
    
    // First level: Create inverted inputs using NAND
    nand nand1(not_a, a, a);
    nand nand2(not_b, b, b);
    
    // Second level: Create OR function (using De Morgan's)
    nand nand3(or_ab, not_a, not_b);
    
    // Final inversion to get NOR
    nand nand4(out, or_ab, or_ab);
endmodule