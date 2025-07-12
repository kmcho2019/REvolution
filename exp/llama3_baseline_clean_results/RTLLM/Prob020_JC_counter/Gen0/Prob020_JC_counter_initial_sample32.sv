module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter value to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // If the least significant bit (Q[0]) is 0, increment the counter
        if (Q[0] == 1'b0) begin
            // Shift the current value (Q[63:1]) to the right and append a 1 at the most significant bit position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If the least significant bit (Q[0]) is 1, decrement the counter
            // Shift the current value (Q[63:1]) to the right and append a 0 at the most significant bit position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule