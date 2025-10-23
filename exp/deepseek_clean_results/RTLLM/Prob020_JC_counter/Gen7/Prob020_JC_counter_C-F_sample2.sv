module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Help with timing closure
// synthesis attribute shreg_extract of Q is "no";  // Prevent shift register optimization

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears the counter to all zeros
    end else begin
        /* Johnson Counter Operation:
         * 1. When LSB (Q[0]) is 0: Right shift and inject 1 at MSB (counting up phase)
         *    Pattern: 000...0 → 100...0 → 110...0 → ... → 111...1
         * 2. When LSB (Q[0]) is 1: Right shift and inject 0 at MSB (counting down phase)
         *    Pattern: 111...1 → 011...1 → 001...1 → ... → 000...0
         * This creates the complete 128-state Johnson counter cycle (2N states for N bits)
         */
        Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
    end
end

endmodule