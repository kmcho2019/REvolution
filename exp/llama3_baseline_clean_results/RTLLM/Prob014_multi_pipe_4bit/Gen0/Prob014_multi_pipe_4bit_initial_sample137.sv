module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_product;
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        sum_reg1 <= partial_product;
        sum_reg2 <= sum_reg1;
        mul_out <= sum_reg2;
    end
end

always @ (*) begin
    partial_product = 8'd0;
    for (int i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            partial_product = partial_product + (mul_a << i);
        end
    end
end

endmodule