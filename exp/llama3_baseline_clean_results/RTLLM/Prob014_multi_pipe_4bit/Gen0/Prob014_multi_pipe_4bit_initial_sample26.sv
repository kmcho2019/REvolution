module multi_pipe_4bit(
    clk, 
    rst_n, 
    mul_a, 
    mul_b, 
    mul_out
);

parameter size = 4;

input clk;
input rst_n;
input [size-1:0] mul_a;
input [size-1:0] mul_b;
output [2*size-1:0] mul_out;

reg [2*size-1:0] mul_out;
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 'd0;
        sum_reg2 <= 'd0;
        mul_out <= 'd0;
    end else begin
        sum_reg1 <= 'd0;
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                sum_reg1 <= sum_reg1 + (mul_a << i);
            end
        end
        sum_reg2 <= sum_reg1;
        mul_out <= sum_reg2;
    end
end

endmodule