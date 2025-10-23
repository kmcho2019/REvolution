module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Reset to all zeros
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};  // Right shift and set MSB to 1
        end else begin
            Q <= {1'b0, Q[63:1]};  // Right shift and set MSB to 0
        end
    end
end

endmodule