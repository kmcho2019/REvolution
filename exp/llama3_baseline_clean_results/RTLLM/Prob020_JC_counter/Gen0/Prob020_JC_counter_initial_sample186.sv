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
        // Update Q based on the least significant bit
        if (Q[0] == 1'b0) begin
            // Increment: Shift Q[63:1] to the right and append a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: Shift Q[63:1] to the right and append a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule