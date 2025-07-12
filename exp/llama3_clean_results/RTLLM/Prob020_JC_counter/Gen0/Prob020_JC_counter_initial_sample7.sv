module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: set counter value to 0
        Q <= 64'd0;
    end else begin
        // Check the least significant bit (Q[0]) of the counter value
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, shift the current value to the right and append a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, shift the current value to the right and append a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule