module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Synthesis optimization attributes
// synthesis attribute async_reg of Q is "true";  // Better metastability handling
// synthesis attribute shreg_extract of Q is "no"; // Prevent SRL conversion

// Power optimization hint
// synopsys translate_off
// Consider clock gating during stable states (all 1s or 0s)
// synopsys translate_on

/* Johnson Counter Operation:
 * - Reset: Clears all bits (active-low synchronous reset)
 * - Normal operation: Right shift with inverted LSB as new MSB
 * - Complete cycle: 128 states (2N for N=64 bits)
 * PPA Notes:
 * - For timing: Critical path is 64-bit shift + inversion
 * - For power: Clock gating opportunities exist during stable states
 * - For area: Consider custom shift register implementations
 */
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end
    else begin
        Q <= {~Q[0], Q[63:1]};  // Johnson counter operation
    end
end

endmodule