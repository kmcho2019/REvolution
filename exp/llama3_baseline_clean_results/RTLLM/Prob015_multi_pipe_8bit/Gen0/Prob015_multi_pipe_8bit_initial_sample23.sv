module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input  [7:0]        mul_a,
    input  [7:0]        mul_b,
    output              mul_en_out,
    output [15:0]       mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp;
reg [15:0] sum [7:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'd0;
        end
    end else if (mul_en_in) begin
        mul_en_out_reg <= mul_en_in;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= (mul_b[i]? (mul_a << i) : 16'd0);
        end
        mul_out_reg <= 16'd0;
        for (int i = 0; i < 8; i++) begin
            mul_out_reg <= mul_out_reg + sum[i];
        end
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= sum[i];
        end
        mul_out_reg <= mul_out_reg;
    end
end

assign mul_en_out = mul_en_out_reg[7];
assign mul_out = (mul_en_out)? mul_out_reg : 16'd0;

endmodule