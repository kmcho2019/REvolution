// Module JC_counter: 64-bit Johnson counter with PPA optimizations
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Always block for sequential logic with clock gating consideration
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Update Q based on the current state (Q[0])
        // If Q[0] is 1, shift right and append 0; otherwise, shift right and append 1
        // This operation is optimized for combinational logic
        Q <= {Q[0]? 1'b0 : 1'b1, Q[63:1]};
    end
end

endmodule