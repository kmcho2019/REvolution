module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        sum <= 0;
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg[7]) begin
        temp[0] = (mul_b_reg[0] == 1) ? {8{mul_a_reg[0]}}, mul_a_reg : 16'd0;
        temp[1] = (mul_b_reg[1] == 1) ? {7{mul_a_reg[1]}}, mul_a_reg, 1'b0 : 16'd0;
        temp[2] = (mul_b_reg[2] == 1) ? {6{mul_a_reg[2]}}, mul_a_reg, 2'b0 : 16'd0;
        temp[3] = (mul_b_reg[3] == 1) ? {5{mul_a_reg[3]}}, mul_a_reg, 3'b0 : 16'd0;
        temp[4] = (mul_b_reg[4] == 1) ? {4{mul_a_reg[4]}}, mul_a_reg, 4'b0 : 16'd0;
        temp[5] = (mul_b_reg[5] == 1) ? {3{mul_a_reg[5]}}, mul_a_reg, 5'b0 : 16'd0;
        temp[6] = (mul_b_reg[6] == 1) ? {2{mul_a_reg[6]}}, mul_a_reg, 6'b0 : 16'd0;
        temp[7] = (mul_b_reg[7] == 1) ? {1{mul_a_reg[7]}}, mul_a_reg, 7'b0 : 16'd0;
        temp[8] = (mul_b_reg[0] == 1) ? {8{mul_a_reg[0]}}, mul_a_reg : 16'd0;
        temp[9] = (mul_b_reg[1] == 1) ? {7{mul_a_reg[1]}}, mul_a_reg, 1'b0 : 16'd0;
        temp[10] = (mul_b_reg[2] == 1) ? {6{mul_a_reg[2]}}, mul_a_reg, 2'b0 : 16'd0;
        temp[11] = (mul_b_reg[3] == 1) ? {5{mul_a_reg[3]}}, mul_a_reg, 3'b0 : 16'd0;
        temp[12] = (mul_b_reg[4] == 1) ? {4{mul_a_reg[4]}}, mul_a_reg, 4'b0 : 16'd0;
        temp[13] = (mul_b_reg[5] == 1) ? {3{mul_a_reg[5]}}, mul_a_reg, 5'b0 : 16'd0;
        temp[14] = (mul_b_reg[6] == 1) ? {2{mul_a_reg[6]}}, mul_a_reg, 6'b0 : 16'd0;
        temp[15] = (mul_b_reg[7] == 1) ? {1{mul_a_reg[7]}}, mul_a_reg, 7'b0 : 16'd0;
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        mul_out_reg <= sum;
    end
end

always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg[7];
    mul_out <= mul_out_reg;
end

endmodule