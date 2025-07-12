// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Internal clock enable signal
reg clk_enable;

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    // Check for reset condition
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
        clk_enable <= 1'b0;
    end else begin
        // Normal operation
        if (Q == 64'd0 || Q[0] == 1'b1) begin
            // Enable clock for next cycle
            clk_enable <= 1'b1;
        end else begin
            // Disable clock for next cycle if not needed
            clk_enable <= 1'b0;
        end
        
        if (clk_enable) begin
            if (Q[0] == 1'b0) begin
                // Increment: shift Q[63:1] to the right and append 1
                Q <= {1'b1, Q[63:1]};
            end else begin
                // Decrement: shift Q[63:1] to the right and append 0
                Q <= {1'b0, Q[63:1]};
            end
        end
    end
end

endmodule