module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition, set counter value to 0
        Q <= 64'd0;
    end else begin
        // Determine next state based on the least significant bit
        if (Q[0] == 1'b0) begin
            // Increment counter by shifting right and appending 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement counter by shifting right and appending 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule