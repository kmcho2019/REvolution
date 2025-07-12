module multi_pipe_8bit (
    input  clk,
    input  rst_n,
    input  mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output reg  mul_en_out,
    output reg [15:0] mul_out
);

// Input Control
reg [1:0] mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 2'b00;
    end else begin
        mul_en_out_reg <= {mul_en_in, mul_en_out_reg[0]};
    end
end
assign mul_en_out = mul_en_out_reg[1];

// Input Registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk) begin
    if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
wire [7:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? {8{1'b0}} + (mul_a_reg << i) : {8{1'b0}};
    end
endgenerate

// Partial Sum Calculation
reg [15:0] sum [7:0];
always @(posedge clk) begin
    sum[0] <= (mul_en_in) ? temp[0] : sum[0];
    for (i = 1; i < 8; i++) begin
        sum[i] <= (mul_en_in) ? sum[i-1] + temp[i] : sum[i];
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
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