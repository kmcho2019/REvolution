module JC_counter(
    input           clk,
    input           rst_n,
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition, set counter value to 0
        Q <= 64'd0;
    end else begin
        // Check the least significant bit (LSB) of the counter
        if (Q[0] == 1'b0) begin
            // Increment the counter by shifting right and appending a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement the counter by shifting right and appending a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule