module JC_counter(
    input           clk,        // Clock signal
    input           rst_n,      // Active-low reset signal
    output reg [63:0] Q         // 64-bit register representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;           // Reset the counter when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            // Increment the counter by shifting the current value to the right and appending a 1 at the most significant bit position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement the counter by shifting the current value to the right and appending a 0 at the most significant bit position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule