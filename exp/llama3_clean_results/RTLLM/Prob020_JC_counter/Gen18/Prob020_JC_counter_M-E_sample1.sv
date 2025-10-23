// Module JC_counter: 64-bit Johnson counter with novel architecture
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Internal signal to store the next state
reg [63:0] next_Q;

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Determine the next state based on the current state's least significant bit
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, append 1 to the most significant bit
            next_Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, append 0 to the most significant bit
            next_Q <= {1'b0, Q[63:1]};
        end
        
        // Update Q with the next state
        Q <= next_Q;
    end
end

endmodule