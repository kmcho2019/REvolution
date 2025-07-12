module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "no";

/* Johnson Counter Operation:
 * - Reset: Clears all bits (active-low)
 * - Normal operation: Right shift with inverted LSB as new MSB
 * - Complete cycle: 128 states (2N for N=64 bits)
 * PPA Notes:
 * - For timing: Critical path is 64-bit shift + inversion
 * - For power: Consider clock gating during predictable states
 */
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Efficient Johnson counter operation
    end
end

endmodule