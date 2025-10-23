module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0 when reset signal is low
        Q <= 64'd0;
    end else begin
        // Check the least significant bit (Q[0])
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, increment the counter by shifting right and appending 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, decrement the counter by shifting right and appending 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule