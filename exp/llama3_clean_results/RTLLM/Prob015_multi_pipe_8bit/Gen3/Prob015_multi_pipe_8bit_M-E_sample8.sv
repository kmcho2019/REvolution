module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;
reg [15:0] partial_product_reg [7:0];
reg [15:0] partial_sum_reg;
reg [15:0] final_product_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
        for (int i = 0; i < 8; i++) begin
            partial_product_reg[i] <= 16'd0;
        end
        partial_sum_reg <= 16'd0;
        final_product_reg <= 16'd0;
    end else begin
        // Stage 1: Input Control
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= 1'b1;
        end else begin
            mul_en_out_reg <= 1'b0;
        end

        // Stage 2: Partial Product Generation
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                partial_product_reg[i] <= {8'd0, mul_a_reg} << i;
            end else begin
                partial_product_reg[i] <= 16'd0;
            end
        end

        // Stage 3: Partial Sum Calculation
        partial_sum_reg <= partial_product_reg[0];
        for (int i = 1; i < 8; i++) begin
            partial_sum_reg <= partial_sum_reg + partial_product_reg[i];
        end

        // Stage 4: Output
        final_product_reg <= partial_sum_reg;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? final_product_reg : 16'd0;

endmodule