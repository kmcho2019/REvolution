module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum [7:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= (mul_b[i] == 1'b1)? (mul_a << i) : 16'b0;
        end
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
        for (int i = 0; i < 7; i++) begin
            sum[i] <= sum[i + 1];
        end
        sum[7] <= 16'b0;
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        if (mul_en_in) begin
            mul_out_reg <= 16'b0;
        end else begin
            for (int i = 0; i < 8; i++) begin
                mul_out_reg <= mul_out_reg + sum[i];
            end
        end
    end else begin
        mul_out_reg <= 16'b0;
    end
end

assign mul_en_out = mul_en_out_reg[7];
assign mul_out = (mul_en_out)? mul_out_reg : 16'b0;

endmodule