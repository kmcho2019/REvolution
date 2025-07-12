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
        // If Q[0] is 0, increment the counter by shifting the current value to the right and appending a 1 at the most significant bit position
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};
        end 
        // If Q[0] is 1, decrement the counter by shifting the current value to the right and appending a 0 at the most significant bit position
        else begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule