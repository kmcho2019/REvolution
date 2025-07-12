module multi_pipe_8bit(
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input      [7:0]    mul_a,
    input      [7:0]    mul_b,
    output              mul_en_out,
    output     [15:0]   mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp;
wire [15:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        mul_out_reg <= sum;
    end
end

assign temp = {16{1'b0}};
assign sum = {16{1'b0}};

integer i;
always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i] == 1'b1) begin
            temp[7 + i: i] = mul_a_reg;
        end
    end
    sum = 16'b0;
    for (i = 0; i < 8; i = i + 1) begin
        sum = sum + {8'b0, temp[7 + i: i]};
    end
end

assign mul_en_out = mul_en_out_reg[0];
assign mul_out = (mul_en_out)? mul_out_reg : 16'b0;

endmodule