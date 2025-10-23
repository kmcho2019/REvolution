module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set counter value to 0
        Q <= 64'd0;
    end else begin
        // Update counter value based on the current state
        if (Q[0] == 1'b0) begin
            // Increment: shift right and append 1 at the most significant bit position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift right and append 0 at the most significant bit position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule