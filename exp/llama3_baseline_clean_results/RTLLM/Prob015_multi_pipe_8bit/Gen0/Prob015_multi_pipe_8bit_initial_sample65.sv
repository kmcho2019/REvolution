module multi_pipe_8bit(
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
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial Product Generation
assign temp[0] = (mul_a_reg[0] && mul_b_reg[0]) ? 8'h01 : 8'h00;
assign temp[1] = (mul_a_reg[1] && mul_b_reg[0]) ? 8'h02 : 8'h00;
assign temp[2] = (mul_a_reg[2] && mul_b_reg[0]) ? 8'h04 : 8'h00;
assign temp[3] = (mul_a_reg[3] && mul_b_reg[0]) ? 8'h08 : 8'h00;
assign temp[4] = (mul_a_reg[4] && mul_b_reg[0]) ? 8'h10 : 8'h00;
assign temp[5] = (mul_a_reg[5] && mul_b_reg[0]) ? 8'h20 : 8'h00;
assign temp[6] = (mul_a_reg[6] && mul_b_reg[0]) ? 8'h40 : 8'h00;
assign temp[7] = (mul_a_reg[7] && mul_b_reg[0]) ? 8'h80 : 8'h00;
assign temp[8] = (mul_a_reg[0] && mul_b_reg[1]) ? 8'h02 : 8'h00;
assign temp[9] = (mul_a_reg[1] && mul_b_reg[1]) ? 8'h04 : 8'h00;
assign temp[10] = (mul_a_reg[2] && mul_b_reg[1]) ? 8'h08 : 8'h00;
assign temp[11] = (mul_a_reg[3] && mul_b_reg[1]) ? 8'h10 : 8'h00;
assign temp[12] = (mul_a_reg[4] && mul_b_reg[1]) ? 8'h20 : 8'h00;
assign temp[13] = (mul_a_reg[5] && mul_b_reg[1]) ? 8'h40 : 8'h00;
assign temp[14] = (mul_a_reg[6] && mul_b_reg[1]) ? 8'h80 : 8'h00;
assign temp[15] = (mul_a_reg[7] && mul_b_reg[1]) ? 16'h100 : 16'h00;

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
    end else if (mul_en_in) begin
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7] + temp[8] + temp[9] + temp[10] + temp[11] + temp[12] + temp[13] + temp[14] + temp[15];
    end else begin
        sum <= sum;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_out) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output Assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'h0000;

endmodule