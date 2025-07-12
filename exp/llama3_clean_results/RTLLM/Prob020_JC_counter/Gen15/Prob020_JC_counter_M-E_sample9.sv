// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal register to hold the next state
reg [63:0] next_Q;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Set Q to 0 when rst_n is low
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        // Determine the next state based on the current state (Q[0])
        case (Q[0])
            1'b0: next_Q = {1'b1, Q[63:1]}; // Increment: Shift right and append 1
            1'b1: next_Q = {1'b0, Q[63:1]}; // Decrement: Shift right and append 0
            default: next_Q = Q; // This should never happen, but included for completeness
        endcase
        Q <= next_Q;
    end
end

endmodule