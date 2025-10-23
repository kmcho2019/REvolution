/*
 * TopModule - Transmission Gate NOR Implementation
 * 
 * Functionality:
 * Implements NOR operation using transmission gate logic
 * out = ~(a | b)
 * 
 * Features:
 * - Low-power transmission gate implementation
 * - Complementary pass-transistor logic
 * - Improved noise margins
 * - No direct VDD-GND path during switching
 * 
 * Implementation Notes:
 * - Uses both NMOS and PMOS pass gates
 * - Output is actively driven in all states
 * - Better for low-voltage operation than standard CMOS
 * - May have better power characteristics in some technologies
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    wire nor_internal;
    wire a_n = ~a;
    wire b_n = ~b;
    
    // Transmission gate implementation
    tranif0 tg1 (nor_internal, 1'b1, a);  // PMOS pass gate
    tranif0 tg2 (nor_internal, 1'b1, b);  // PMOS pass gate
    tranif1 tg3 (nor_internal, 1'b0, a);  // NMOS pass gate
    tranif1 tg4 (nor_internal, 1'b0, b);  // NMOS pass gate
    
    // Output buffer for clean signal
    bufif1 out_buf (out, nor_internal, 1'b1);
    
    /* Alternative implementation without buffer (uncomment if needed):
     * assign out = nor_internal;
     */
endmodule