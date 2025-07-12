module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline register for intermediate sum
reg [7:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Generate and accumulate partial products
        sum_reg <= (mul_b[0] ? {4'd0, mul_a} : 8'd0) +
                   (mul_b[1] ? {3'd0, mul_a, 1'd0} : 8'd0) +
                   (mul_b[2] ? {2'd0, mul_a, 2'd0} : 8'd0) +
                   (mul_b[3] ? {1'd0, mul_a, 3'd0} : 8'd0);
        
        // Final output register
        mul_out <= sum_reg;
    end
end

endmodule