module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is "true";  // Helps with timing closure
// synthesis attribute shreg_extract of Q is "no";  // Prevent unwanted optimization

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        /* Johnson Counter Operation:
         * - When Q[0]==0: Right shift and insert 1 at MSB (counting up: 0→1)
         * - When Q[0]==1: Right shift and insert 0 at MSB (counting down: 1→0)
         * Complete cycle: 128 states (2N for N=64 bits)
         * PPA Notes:
         * - For timing: Consider pipelining if WNS is negative
         * - For power: Clock gating at extreme states (all 0s/1s)
         * - For area: Evaluate one-hot encoding if full 64-bit state not needed
         */
        Q <= {~Q[0], Q[63:1]};  // Compact ternary equivalent
    end
end

endmodule