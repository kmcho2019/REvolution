module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to all zeros
        Q <= 64'd0;
    end else begin
        // Determine the next state based on the current least significant bit
        if (Q[0] == 1'b0) begin
            // Append a 1 if the least significant bit is 0
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Append a 0 if the least significant bit is 1
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule