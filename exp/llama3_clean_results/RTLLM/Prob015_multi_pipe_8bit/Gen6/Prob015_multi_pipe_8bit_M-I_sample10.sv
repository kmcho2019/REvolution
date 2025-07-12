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
reg [15:0] product_reg;
reg [2:0] state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        product_reg <= 16'd0;
        state <= 3'd0;
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        case (state)
            3'd0: begin // Idle state
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    product_reg <= 16'd0;
                    state <= 3'd1;
                    mul_en_out <= 1'b1;
                end
            end
            3'd1: begin // Perform multiplication
                if (mul_b_reg!= 8'd0) begin
                    if (mul_b_reg[0] == 1'b1) begin
                        product_reg <= product_reg + {8'd0, mul_a_reg};
                    end
                    mul_b_reg <= mul_b_reg >> 1;
                    mul_a_reg <= mul_a_reg << 1;
                    state <= 3'd1;
                end else begin
                    state <= 3'd2;
                end
            end
            3'd2: begin // Output result
                mul_out <= product_reg;
                state <= 3'd3;
            end
            3'd3: begin // Reset state
                mul_en_out <= 1'b0;
                state <= 3'd0;
            end
            default: state <= 3'd0;
        endcase
    end
end

endmodule