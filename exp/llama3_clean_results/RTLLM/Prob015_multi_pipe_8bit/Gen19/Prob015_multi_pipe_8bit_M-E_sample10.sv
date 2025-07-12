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
reg [2:0] state;
reg [15:0] partial_product_reg;
reg [15:0] partial_sum_reg;
reg [15:0] final_product_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        state <= 3'b000;
        partial_product_reg <= 16'b0;
        partial_sum_reg <= 16'b0;
        final_product_reg <= 16'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        case (state)
            3'b000: begin // idle
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    state <= 3'b001; // multiply
                end
            end
            3'b001: begin // multiply
                reg [15:0] partial_product;
                partial_product = 16'b0;
                for (int i = 0; i < 8; i++) begin
                    if (mul_b_reg[i]) begin
                        partial_product += {8'b0, mul_a_reg} << i;
                    end
                end
                partial_product_reg <= partial_product;
                state <= 3'b010; // partial sum
            end
            3'b010: begin // partial sum
                reg [15:0] partial_sum;
                partial_sum = partial_product_reg;
                for (int i = 0; i < 8; i++) begin
                    if (mul_b_reg[i]) begin
                        partial_sum += {8'b0, mul_a_reg} << i;
                    end
                end
                partial_sum_reg <= partial_sum;
                state <= 3'b100; // final product
            end
            3'b100: begin // final product
                final_product_reg <= partial_sum_reg;
                state <= 3'b000; // idle
            end
        endcase
        if (state == 3'b100) begin
            mul_en_out <= 1'b1;
            mul_out <= final_product_reg;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end
end

endmodule