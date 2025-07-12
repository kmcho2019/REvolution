/*
 * TopModule - LUT-based NOR Gate Implementation
 * 
 * Functionality:
 * Implements a NOR gate using a 4:1 multiplexer configured as a lookup table
 * 
 * Features:
 * - Demonstrates alternative implementation using multiplexers
 * - Clearly shows the truth table to hardware mapping
 * - Educational value for understanding LUT-based logic
 * - Same interface as standard NOR gate
 * 
 * Implementation Notes:
 * - a and b act as select lines for the 4:1 mux
 * - Data inputs are hardwired to NOR truth table outputs
 * - Less efficient than direct gate implementation but pedagogically useful
 * - Shows how FPGAs implement logic using configurable LUTs
 * 
 * Truth Table Mapping:
 * Selects | Data Input | Out
 * --------------------------
 * 00 (0)  | 1          | 1
 * 01 (1)  | 0          | 0
 * 10 (2)  | 0          | 0
 * 11 (3)  | 0          | 0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    // 4:1 MUX implementation of NOR truth table
    assign out = (a == 0 && b == 0) ? 1'b1 :
                 (a == 0 && b == 1) ? 1'b0 :
                 (a == 1 && b == 0) ? 1'b0 :
                 1'b0;  // a == 1 && b == 1
    
    /* Alternative structural implementation:
    wire [1:0] sel = {a,b};
    wire [3:0] lut = 4'b1000;  // NOR truth table
    assign out = lut[sel];
    */
endmodule