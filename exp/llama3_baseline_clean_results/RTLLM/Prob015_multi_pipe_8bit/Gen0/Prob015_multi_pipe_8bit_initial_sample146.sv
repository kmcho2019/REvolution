module multi_pipe_8bit(
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum [7:1];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
        for (int i = 1; i <= 7; i++) begin
            sum[i] <= 16'd0;
        end
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        
        // Partial product generation
        for (int i = 0; i <= 7; i++) begin
            reg [15:0] temp;
            if (mul_b_reg[i]) begin
                temp = {8'd0, mul_a_reg} << i;
            end else begin
                temp = 16'd0;
            end
            
            // Partial sum calculation
            if (i == 0) begin
                sum[i+1] <= temp;
            end else begin
                sum[i+1] <= sum[i] + temp;
            end
        end
        
        // Final product calculation
        mul_out_reg <= sum[7] + sum[6] + sum[5] + sum[4] + sum[3] + sum[2] + sum[1];
    end
end

assign mul_en_out = mul_en_out_reg[0];
assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule