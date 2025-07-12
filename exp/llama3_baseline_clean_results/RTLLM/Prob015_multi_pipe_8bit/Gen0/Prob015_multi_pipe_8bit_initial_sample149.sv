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
reg mul_en_out_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

assign mul_en_out = mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= mul_en_in;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

always @(*) begin
    temp = {16{1'b0}};
    for (int i = 0; i < 8; i++) begin
        if (mul_b_reg[i]) begin
            temp = temp + (mul_a_reg << i);
        end
    end
end

always @(posedge clk) begin
    sum <= temp;
    mul_out_reg <= sum;
end

assign mul_out = (mul_en_out_reg)? mul_out_reg : {16{1'b0}};

endmodule