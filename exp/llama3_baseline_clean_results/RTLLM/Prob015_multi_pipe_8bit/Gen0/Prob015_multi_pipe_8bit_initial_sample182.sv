module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input      [7:0]    mul_a,
    input      [7:0]    mul_b,
    output              mul_en_out,
    output     [15:0]   mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] mul_en_out_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum [7:0];

wire [15:0] temp [7:0];

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1, mul_en_out_reg[6:0]};
    end else begin
        mul_en_out_reg <= {1'b0, mul_en_out_reg[6:0]};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
always @(posedge clk) begin
    if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
integer i;
always @(*) begin
    for (i = 0; i < 8; i++) begin
        temp[i] = (mul_a_reg << i) * mul_b_reg[i];
    end
end

// Partial Sum Calculation
integer j;
always @(posedge clk) begin
    for (j = 0; j < 8; j++) begin
        sum[j] <= (j == 0) ? temp[j] : sum[j-1] + temp[j];
    end
end

// Final Product Calculation
always @(posedge clk) begin
    mul_out_reg <= sum[7];
end

// Output Assignment
always @(posedge clk) begin
    if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule