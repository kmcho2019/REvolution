// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        Q <= '0; // Set all bits to 0 for reset
    end else begin // Normal operation
        // Update counter value with optimized logic
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]}; // Increment by shifting right and appending 1
        end else begin
            Q <= {1'b0, Q[63:1]}; // Decrement by shifting right and appending 0
        end
    end
end

endmodule