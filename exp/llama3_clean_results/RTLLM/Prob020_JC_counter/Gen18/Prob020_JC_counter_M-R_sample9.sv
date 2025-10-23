// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Variable to hold the next state of Q
reg [63:0] next_Q;

// Combinational logic for the next state of Q
always @* begin
    if (~Q[0]) begin
        // If Q[0] is 0, the counter increments
        next_Q = {1'b1, Q[63:1]};
    end else begin
        // If Q[0] is 1, the counter decrements
        next_Q = {1'b0, Q[63:1]};
    end
end

// Sequential logic for updating Q based on the clock and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // Update Q with the next state
        Q <= next_Q;
    end
end

endmodule