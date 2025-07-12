module multi_pipe_8bit(
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

reg [15:0] mul_out_reg;
reg         mul_en_out_reg;

wire [15:0] temp;

// Input control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation
assign temp[0]  = (mul_b[0] == 1'b1)? {8'b0, mul_a_reg} : 16'b0;
assign temp[1]  = (mul_b[1] == 1'b1)? {8'b0, mul_a_reg} << 1 : 16'b0;
assign temp[2]  = (mul_b[2] == 1'b1)? {8'b0, mul_a_reg} << 2 : 16'b0;
assign temp[3]  = (mul_b[3] == 1'b1)? {8'b0, mul_a_reg} << 3 : 16'b0;
assign temp[4]  = (mul_b[4] == 1'b1)? {8'b0, mul_a_reg} << 4 : 16'b0;
assign temp[5]  = (mul_b[5] == 1'b1)? {8'b0, mul_a_reg} << 5 : 16'b0;
assign temp[6]  = (mul_b[6] == 1'b1)? {8'b0, mul_a_reg} << 6 : 16'b0;
assign temp[7]  = (mul_b[7] == 1'b1)? {8'b0, mul_a_reg} << 7 : 16'b0;

// Partial sum calculation
reg [15:0] sum_reg1;
reg [15:0] sum_reg2;
reg [15:0] sum_reg3;
reg [15:0] sum_reg4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 16'b0;
        sum_reg2 <= 16'b0;
        sum_reg3 <= 16'b0;
        sum_reg4 <= 16'b0;
    end else if (mul_en_in) begin
        sum_reg1 <= temp[0] + temp[1];
        sum_reg2 <= temp[2] + temp[3];
        sum_reg3 <= temp[4] + temp[5];
        sum_reg4 <= temp[6] + temp[7];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_out_reg) begin
        mul_out_reg <= sum_reg1 + (sum_reg2 << 2) + (sum_reg3 << 4) + (sum_reg4 << 6);
    end
end

// Output assignment
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule