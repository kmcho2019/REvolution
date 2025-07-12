module multi_pipe_4bit(
    input clk, 
    input rst_n, 
    input [3:0] mul_a, 
    input [3:0] mul_b, 
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1 [3:0];
reg [7:0] sum_reg2;
reg [7:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 8'd0;
            sum_reg1[i] <= 8'd0;
        end
        sum_reg2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i])
                partial_product[i] <= {4'd0, mul_a} << i;
            else
                partial_product[i] <= 8'd0;
            if (i == 0)
                sum_reg1[i] <= partial_product[i];
            else
                sum_reg1[i] <= sum_reg1[i-1] + partial_product[i];
        end
        sum_reg2 <= sum_reg1[size-1];
        mul_out_reg <= sum_reg2;
    end
end

assign mul_out = mul_out_reg;

endmodule