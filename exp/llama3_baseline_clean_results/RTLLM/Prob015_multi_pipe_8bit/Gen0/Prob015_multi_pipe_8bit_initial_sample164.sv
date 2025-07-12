module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;

wire [15:0] temp;
wire [15:0] sum;

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_out_reg <= 0;
    end else begin
        mul_en_out_reg <= {mul_en_in, 1'b0};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        if (mul_en_out_reg[0]) begin
            // Partial product generation
            temp[0] = (mul_b_reg[0]) ? {8'd0, mul_a_reg} : 16'd0;
            temp[1] = (mul_b_reg[1]) ? {7'd0, mul_a_reg, 1'd0} : 16'd0;
            temp[2] = (mul_b_reg[2]) ? {6'd0, mul_a_reg, 2'd0} : 16'd0;
            temp[3] = (mul_b_reg[3]) ? {5'd0, mul_a_reg, 3'd0} : 16'd0;
            temp[4] = (mul_b_reg[4]) ? {4'd0, mul_a_reg, 4'd0} : 16'd0;
            temp[5] = (mul_b_reg[5]) ? {3'd0, mul_a_reg, 5'd0} : 16'd0;
            temp[6] = (mul_b_reg[6]) ? {2'd0, mul_a_reg, 6'd0} : 16'd0;
            temp[7] = (mul_b_reg[7]) ? {1'd0, mul_a_reg, 7'd0} : 16'd0;
            temp[8] = 16'd0;
            temp[9] = 16'd0;
            temp[10] = 16'd0;
            temp[11] = 16'd0;
            temp[12] = 16'd0;
            temp[13] = 16'd0;
            temp[14] = 16'd0;
            temp[15] = 16'd0;
            
            // Partial sum calculation
            sum = temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
            mul_out_reg <= sum;
        end else begin
            mul_out_reg <= 0;
        end
    end
end

assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule