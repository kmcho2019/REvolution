// Module JC_counter: 64-bit Johnson counter with optimizations
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Always block: synchronous operation with clock gating consideration
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else if (Q == 64'd0) begin
        // Handle the initial state
        Q <= {1'd1, 63'd0};
    end else begin
        // Update Q based on the current state (Q[0])
        // If Q[0] is 1, shift right and append 0; otherwise, shift right and append 1
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule