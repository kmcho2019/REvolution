module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

wire [15:0] temp;
wire [15:0] sum;

assign mul_en_out = mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 0;
        end
        
        if (mul_en_out_reg) begin
            temp[0]  = mul_a_reg[0]? (mul_b_reg << 0) : 0;
            temp[1]  = mul_a_reg[1]? (mul_b_reg << 1) : 0;
            temp[2]  = mul_a_reg[2]? (mul_b_reg << 2) : 0;
            temp[3]  = mul_a_reg[3]? (mul_b_reg << 3) : 0;
            temp[4]  = mul_a_reg[4]? (mul_b_reg << 4) : 0;
            temp[5]  = mul_a_reg[5]? (mul_b_reg << 5) : 0;
            temp[6]  = mul_a_reg[6]? (mul_b_reg << 6) : 0;
            temp[7]  = mul_a_reg[7]? (mul_b_reg << 7) : 0;
            
            sum[0]  = temp[0];
            sum[1]  = sum[0] + temp[1];
            sum[2]  = sum[1] + temp[2];
            sum[3]  = sum[2] + temp[3];
            sum[4]  = sum[3] + temp[4];
            sum[5]  = sum[4] + temp[5];
            sum[6]  = sum[5] + temp[6];
            sum[7]  = sum[6] + temp[7];
            
            mul_out_reg <= sum[7];
        end else begin
            mul_out_reg <= 0;
        end
    end
end

assign mul_out = (mul_en_out)? mul_out_reg : 0;

endmodule