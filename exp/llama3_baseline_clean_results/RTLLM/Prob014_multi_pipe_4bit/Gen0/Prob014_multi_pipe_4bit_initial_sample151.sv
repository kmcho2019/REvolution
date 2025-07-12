module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg;
reg [2*size-1:0] sum_reg_out;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 'd0;
        sum_reg_out <= 'd0;
    end else begin
        sum_reg <= 'd0;
        sum_reg_out <= 'd0;
        for (int i = 0; i < size; i++) begin
            partial_product[i] <= (mul_b[i] == 1'b1) ? (mul_a << i) : 'd0;
            if (i == 0) begin
                sum_reg <= partial_product[i];
            end else begin
                sum_reg <= sum_reg + partial_product[i];
            end
        end
        sum_reg_out <= sum_reg;
    end
end

always @(posedge clk) begin
    mul_out <= sum_reg_out;
end

endmodule