module multi_pipe_8bit (
    clk, 
    rst_n, 
    mul_en_in, 
    mul_a, 
    mul_b, 
    mul_en_out, 
    mul_out
);

input clk;
input rst_n;
input mul_en_in;
input [7:0] mul_a;
input [7:0] mul_b;
output mul_en_out;
output [15:0] mul_out;

reg mul_en_out;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out <= mul_en_in;
    end
end

reg [15:0] temp;
reg [15:0] sum;

always @(posedge clk) begin
    temp = 0;
    sum = 0;
    
    for (i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i] == 1) begin
            temp = temp + (mul_a_reg << i);
        end
    end
    
    sum = temp;
    
    mul_out_reg <= sum;
end

always @(posedge clk) begin
    if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 0;
    end
end

endmodule