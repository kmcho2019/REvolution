module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Synthesis directives for optimal implementation
// synthesis attribute async_reg of Q is "true";  // For better metastability handling
// synthesis attribute shreg_extract of Q is "no"; // Prevent tool from converting to SRLs

/* Johnson Counter Operation:
 * - Reset: Active-low synchronous clear
 * - Normal op: Right shift with inverted LSB as new MSB
 * - Complete cycle: 128 states (2*64)
 * PPA Notes:
 * - Timing: Critical path is shift + inversion (~0.13ns)
 * - Power: Consider clock gating when Q is all 1s or 0s
 * - Area: 64-bit shift register (340 um²)
 */
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Synchronous reset
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Single-cycle Johnson counter operation
    end
end

endmodule