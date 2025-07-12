/*
 * TopModule - NOR Gate Implemented Using NAND Gates (Universal Gate Approach)
 * 
 * Functionality:
 * Implements a NOR gate using only NAND gates (a | b)' = (a' & b') = (a' nand b')'
 * 
 * Implementation Details:
 * - Uses three NAND gates:
 *   1. First NAND acts as inverter for input a (a nand a)
 *   2. Second NAND acts as inverter for input b (b nand b)
 *   3. Third NAND combines inverted inputs
 * - Final output is inverted to complete the NOR function
 * 
 * Truth Table (per bit):
 * a b | a' b' | a' nand b' | out (NOR)
 * -------------------------------------
 * 0 0 | 1  1  |     0      |   1
 * 0 1 | 1  0  |     1      |   0
 * 1 0 | 0  1  |     1      |   0
 * 1 1 | 0  0  |     1      |   0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    // Internal wires for inverted inputs
    wire a_nand_a, b_nand_b;
    
    // First NAND gate - inverts input a (a nand a = a')
    assign a_nand_a = ~(a & a);
    
    // Second NAND gate - inverts input b (b nand b = b')
    assign b_nand_b = ~(b & b);
    
    // Third NAND gate combines inverted inputs (a' nand b')
    // Then invert to get (a' & b') which equals (a | b)'
    assign out = ~(a_nand_a & b_nand_b);
endmodule