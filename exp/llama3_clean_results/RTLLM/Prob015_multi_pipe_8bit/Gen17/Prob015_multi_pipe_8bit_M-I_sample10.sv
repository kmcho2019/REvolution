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
reg [1:0] state;
reg [15:0] sum_reg;
reg [15:0] partial_product_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        state <= 2'b00;
        sum_reg <= 16'b0;
        partial_product_reg <= 16'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    state <= 2'b01; // multiply
                end
            end
            2'b01: begin // multiply
                reg [15:0] partial_product;
                partial_product = 16'b0;
                for (int i = 0; i < 8; i++) begin
                    if (mul_b_reg[i]) begin
                        partial_product += {8'b0, mul_a_reg} << i;
                    end
                end
                partial_product_reg <= partial_product;
                state <= 2'b10; // done
            end
            2'b10: begin // done
                if (!mul_en_in) begin
                    state <= 2'b00; // idle
                end
            end
        endcase
        if (state == 2'b10) begin
            mul_en_out <= 1'b1;
            mul_out <= partial_product_reg;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end
end

endmodule