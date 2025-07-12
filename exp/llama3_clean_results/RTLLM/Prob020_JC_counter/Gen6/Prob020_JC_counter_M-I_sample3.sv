module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0.
        Q <= 64'd0;
    end else begin
        // Simplify the conditional logic by directly assigning based on Q[0].
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, increment by shifting right and appending 1.
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, decrement by shifting right and appending 0.
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule