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
wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= {mul_en_in, mul_en_out_reg[0]};
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= {1'b0, mul_en_out_reg[0]};
        end
        
        // Partial Product Generation
        assign temp = (mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0) +
                      (mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0) +
                      (mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0) +
                      (mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0) +
                      (mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0) +
                      (mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0) +
                      (mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0) +
                      (mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0);
        
        // Final Product Calculation
        mul_out_reg <= temp;
        
    end
end

assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule