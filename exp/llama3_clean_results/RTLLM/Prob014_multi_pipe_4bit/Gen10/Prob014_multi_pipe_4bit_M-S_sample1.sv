module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 'd0;
        mul_out <= 'd0;
    end else begin
        sum_reg <= 'd0;
        for (integer i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                sum_reg <= sum_reg + ({size{1'b0}, mul_a} << i);
            end
        end
        mul_out <= sum_reg;
    end
end

endmodule