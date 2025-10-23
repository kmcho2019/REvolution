module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;  // Reset the counter to 0 when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};  // Increment: shift right and append 1
        end else begin
            Q <= {1'b0, Q[63:1]};  // Decrement: shift right and append 0
        end
    end
end

endmodule