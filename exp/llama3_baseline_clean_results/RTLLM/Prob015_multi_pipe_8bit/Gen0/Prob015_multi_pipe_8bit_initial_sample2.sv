module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        sum <= 16'b0;
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        if (mul_en_out_reg) begin
            temp[0] = mul_a_reg;
            temp[8] = 8'b0;
            for (int i = 1; i < 8; i++) begin
                if (mul_b_reg[i-1]) begin
                    temp[(i*8)+:8] = mul_a_reg;
                end else begin
                    temp[(i*8)+:8] = 8'b0;
                end
            end
            sum <= {sum[7:0], (temp[7:0] + sum[15:8])};
            if (mul_b_reg[7]) begin
                mul_out_reg <= sum + {8'b0, mul_a_reg};
            end else begin
                mul_out_reg <= sum;
            end
        end
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out? mul_out_reg : 16'b0;

endmodule