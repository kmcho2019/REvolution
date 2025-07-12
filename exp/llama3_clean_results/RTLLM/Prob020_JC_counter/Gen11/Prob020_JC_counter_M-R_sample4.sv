// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // Determine the next state based on the current Q[0]
        reg [63:0] next_Q;
        if (Q[0] == 1'b1) begin
            // If Q[0] is 1, shift right and append 0
            next_Q = {1'b0, Q[63:1]};
        end else begin
            // If Q[0] is 0, shift right and append 1
            next_Q = {1'b1, Q[63:1]};
        end
        Q <= next_Q;
    end
end

endmodule