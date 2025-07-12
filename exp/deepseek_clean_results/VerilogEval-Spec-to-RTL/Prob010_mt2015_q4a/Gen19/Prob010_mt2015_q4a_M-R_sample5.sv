`default_nettype none

/*
 * TopModule - Implements z = (x^y) & x
 * Refactored version showing explicit XOR then AND operations
 * Maintains same PPA metrics as original
 */
module TopModule (
    input  wire x,  // First input
    input  wire y,  // Second input
    output reg  z   // Output (x XOR y) AND x
);
    wire xor_result;  // Intermediate XOR result
    
    // Explicitly compute XOR first
    assign xor_result = x ^ y;
    
    // Then AND with x
    always @(*) begin
        z = xor_result & x;
    end
endmodule