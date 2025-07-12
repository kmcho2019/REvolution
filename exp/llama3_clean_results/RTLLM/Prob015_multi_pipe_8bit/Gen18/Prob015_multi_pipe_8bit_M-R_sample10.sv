module multi_pipe_8bit(
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
reg [15:0] sum_reg;
reg [15:0] partial_product_reg;

// State machine
reg state;
reg next_state;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 1'b0;
    end else begin
        state <= next_state;
    end
end

assign next_state = (state == 1'b0 && mul_en_in) ? 1'b1 : (state == 1'b1 && !mul_en_in) ? 1'b0 : state;

// Input registers
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (state == 1'b0 && mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation
wire [15:0] partial_product;
assign partial_product = (mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0) +
                         (mul_b_reg[1] ? {8'b0, mul_a_reg} << 1 : 16'b0) +
                         (mul_b_reg[2] ? {8'b0, mul_a_reg} << 2 : 16'b0) +
                         (mul_b_reg[3] ? {8'b0, mul_a_reg} << 3 : 16'b0) +
                         (mul_b_reg[4] ? {8'b0, mul_a_reg} << 4 : 16'b0) +
                         (mul_b_reg[5] ? {8'b0, mul_a_reg} << 5 : 16'b0) +
                         (mul_b_reg[6] ? {8'b0, mul_a_reg} << 6 : 16'b0) +
                         (mul_b_reg[7] ? {8'b0, mul_a_reg} << 7 : 16'b0);

// Partial sum calculation
always @(posedge clk) begin
    if (!rst_n) begin
        sum_reg <= 16'b0;
    end else if (state == 1'b1) begin
        sum_reg <= partial_product;
    end
end

// Output assignment
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        mul_en_out <= (state == 1'b1) ? 1'b1 : 1'b0;
        mul_out <= (state == 1'b1) ? sum_reg : 16'b0;
    end
end

endmodule