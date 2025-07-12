module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute keep of Q is true;  // Prevent optimization of critical path
// synthesis attribute async_reg of Q is true;  // Help with timing closure

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        /* Johnson counter operation:
         * When LSB is 0: shift right and set MSB to 1 (counting up)
         * When LSB is 1: shift right and set MSB to 0 (counting down)
         */
        Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
    end
end

endmodule