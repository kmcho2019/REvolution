module multi_pipe_8bit (
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
reg mul_en_out_reg;
reg [15:0] partial_sum_reg;
reg [15:0] final_product_reg;
reg [2:0] state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
        partial_sum_reg <= 16'd0;
        final_product_reg <= 16'd0;
        state <= 3'd0;
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        case (state)
            3'd0: begin // Idle state
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    mul_en_out_reg <= 1'b1;
                    state <= 3'd1;
                end
            end
            3'd1: begin // Start multiplication
                partial_sum_reg <= 16'd0;
                state <= 3'd2;
            end
            3'd2: begin // Perform multiplication and addition
                if (mul_b_reg[0] == 1'b1) begin
                    partial_sum_reg <= partial_sum_reg + {8'd0, mul_a_reg};
                end
                mul_b_reg <= mul_b_reg >> 1;
                mul_a_reg <= {mul_a_reg[6:0], 1'b0}; // Shift left and fill with zero
                if (mul_b_reg == 8'd0) begin
                    final_product_reg <= partial_sum_reg;
                    state <= 3'd3;
                end
            end
            3'd3: begin // Output result
                mul_en_out_reg <= 1'b0;
                state <= 3'd0;
            end
            default: state <= 3'd0;
        endcase
    end
end

always @ (posedge clk) begin
    mul_en_out <= mul_en_out_reg;
    if (mul_en_out_reg) begin
        mul_out <= final_product_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule