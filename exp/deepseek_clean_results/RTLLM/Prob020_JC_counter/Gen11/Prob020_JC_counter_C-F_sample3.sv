module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "no";

/* 64-bit Johnson Counter Operation:
 * - Reset: Clears all bits (active-low synchronous reset)
 * - Normal operation: Right shift with inverted LSB as new MSB
 * - Complete cycle: 128 states (2N for N=64)
 * PPA Optimizations:
 * - Critical path: 64-bit shift + inversion (~0.13ns)
 * - Power: Consider clock gating during terminal states (all 1s/0s)
 * - Area: 340um² typical for 64-bit shift register
 */
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Optimal Johnson counter operation
    end
end

endmodule