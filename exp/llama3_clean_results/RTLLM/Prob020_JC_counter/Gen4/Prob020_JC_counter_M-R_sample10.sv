// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Next state logic
reg [63:0] next_Q;

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    // Check for reset condition
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Normal operation
        if (Q[0] == 1'b0) begin
            // Increment: shift Q[63:1] to the right and append 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift Q[63:1] to the right and append 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule