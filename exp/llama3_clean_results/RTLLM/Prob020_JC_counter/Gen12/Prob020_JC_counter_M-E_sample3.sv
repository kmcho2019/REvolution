module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Normal operation: Append 1 if Q[0] is 0, append 0 if Q[0] is 1
        if (Q[0] == 1'b0) begin
            // Append 1 at MSB position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Append 0 at MSB position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule