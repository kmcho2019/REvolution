// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Set Q to 0 when rst_n is low
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        // Update Q based on the current state (Q[0])
        // If Q[0] is 1, shift right and append 0; otherwise, shift right and append 1
        // This operation is simplified and efficient, minimizing switching activity
        Q <= {Q[63], Q[63:1]};
    end
end

endmodule