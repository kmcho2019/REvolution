module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] mul_en_out_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp;
wire [15:0] sum;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

always @(posedge clk) begin
    temp = 0;
    for (i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i])
            temp = temp + (mul_a_reg << i);
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_out_reg[7]) begin
        mul_out_reg <= temp;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        mul_en_out <= mul_en_out_reg[7];
        if (mul_en_out_reg[7])
            mul_out <= mul_out_reg;
        else
            mul_out <= 0;
    end
end

endmodule