/*
 * TopModule - LUT-Based NOR Gate Implementation
 * 
 * Functionality:
 * Implements a NOR gate using either:
 * 1. Direct NOR operation (default for best PPA)
 * 2. Lookup table implementation (for educational/demonstration purposes)
 * 
 * Features:
 * - Two implementation styles selectable via parameter
 * - LUT version shows FPGA-style implementation
 * - Direct version maintains optimal PPA
 * - Clear documentation of both approaches
 * 
 * Implementation Notes:
 * - LUT_SIZE parameter defines the implementation style
 *   (0 = direct NOR, 1 = LUT-based)
 * - LUT implementation uses a 4-entry memory for the truth table
 * - Direct implementation remains as the default for best PPA
 * 
 * Truth Table (same for both implementations):
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule #(
    parameter LUT_SIZE = 0  // 0 = direct, 1 = LUT-based
) (
    input  a,
    input  b,
    output out
);

generate
    if (LUT_SIZE == 0) begin : direct_impl
        // Direct NOR implementation (optimal PPA)
        assign out = ~(a | b);
    end
    else begin : lut_impl
        // LUT-based implementation (4-entry truth table)
        reg [0:3] nor_lut;
        initial begin
            nor_lut[0] = 1'b1;  // a=0, b=0
            nor_lut[1] = 1'b0;  // a=0, b=1
            nor_lut[2] = 1'b0;  // a=1, b=0
            nor_lut[3] = 1'b0;  // a=1, b=1
        end
        
        // Use inputs as LUT address
        assign out = nor_lut[{a,b}];
    end
endgenerate

endmodule