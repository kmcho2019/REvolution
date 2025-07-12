module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input control and register
reg [0:0] mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg[0];

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
wire [15:0] temp;
assign temp = (mul_b_reg[0] ? mul_a_reg : 16'b0) +
              (mul_b_reg[1] ? {mul_a_reg, 1'b0} : 16'b0) +
              (mul_b_reg[2] ? {mul_a_reg, 2'b0} : 16'b0) +
              (mul_b_reg[3] ? {mul_a_reg, 3'b0} : 16'b0) +
              (mul_b_reg[4] ? {mul_a_reg, 4'b0} : 16'b0) +
              (mul_b_reg[5] ? {mul_a_reg, 5'b0} : 16'b0) +
              (mul_b_reg[6] ? {mul_a_reg, 6'b0} : 16'b0) +
              (mul_b_reg[7] ? {mul_a_reg, 7'b0} : 16'b0);

// Final product calculation and output assignment
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_out) begin
        mul_out_reg <= temp;
    end else begin
        mul_out_reg <= 16'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 16'b0;
    end else begin
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule