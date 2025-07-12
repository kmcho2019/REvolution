module multi_pipe_8bit(
    input  clk,
    input  rst_n,
    input  mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] sum [8:0];
reg [15:0] mul_out_reg;

wire [15:0] temp [7:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (i = 0; i <= 8; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        // Partial product generation
        for (i = 0; i < 8; i++) begin
            temp[i] = (mul_a_reg << i) & {16{mul_b_reg[i]}};
        end
        // Partial sum calculation
        sum[0] <= temp[0];
        for (i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
        sum[8] <= sum[7];
        // Final product calculation
        if (mul_en_in) begin
            mul_out_reg <= sum[8];
        end else begin
            mul_out_reg <= 0;
        end
    end
end

assign mul_en_out = mul_en_out_reg[0];
assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule