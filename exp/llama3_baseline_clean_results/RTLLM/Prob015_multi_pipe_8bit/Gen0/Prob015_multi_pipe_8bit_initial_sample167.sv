module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output             mul_en_out,
    output     [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0]  mul_a_reg;
reg [7:0]  mul_b_reg;
reg [15:0] sum;
reg [15:0] mul_out_reg;
wire [15:0] temp;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg      <= 8'b0;
        mul_b_reg      <= 8'b0;
        sum            <= 16'b0;
        mul_out_reg    <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg      <= mul_a;
            mul_b_reg      <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        // Generate partial products
        if (mul_en_in) begin
            temp[0]  = (mul_b_reg[0] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
            temp[1]  = (mul_b_reg[1] == 1'b1) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
            temp[2]  = (mul_b_reg[2] == 1'b1) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
            temp[3]  = (mul_b_reg[3] == 1'b1) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
            temp[4]  = (mul_b_reg[4] == 1'b1) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
            temp[5]  = (mul_b_reg[5] == 1'b1) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
            temp[6]  = (mul_b_reg[6] == 1'b1) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
            temp[7]  = (mul_b_reg[7] == 1'b1) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;
            // Calculate partial sums
            sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        end else begin
            sum <= 16'b0;
        end
        // Calculate final product
        mul_out_reg <= sum;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out    = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule