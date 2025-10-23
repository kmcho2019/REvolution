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
        Q <= {~Q[0], Q[63:1]}; // Directly update Q based on Q[0]
    end
end

endmodule