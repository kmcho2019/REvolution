module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset counter to 0 when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            // If the least significant bit is 0, shift right and append 1 at the most significant bit
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If the least significant bit is 1, shift right and append 0 at the most significant bit
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule