module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'd0;
    end else begin
        // Update Q based on Q[0]
        // If Q[0] is 0, increment by shifting right and appending 1 at MSB
        // If Q[0] is 1, decrement by shifting right and appending 0 at MSB
        Q <= {~Q[0], Q[63:1]};
        // Alternatively, for clarity and explicitness:
        // if (Q[0] == 1'b0) begin
        //     Q <= {1'b1, Q[63:1]};
        // end else begin
        //     Q <= {1'b0, Q[63:1]};
        // end
    end
end

endmodule