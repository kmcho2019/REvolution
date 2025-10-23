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
reg [15:0] partial_product_reg;
reg [15:0] final_product_reg;

// Stage 1: Input Control
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
        partial_product_reg <= 16'd0;
        final_product_reg <= 16'd0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= 1'b1;
        end else begin
            mul_a_reg <= mul_a_reg;
            mul_b_reg <= mul_b_reg;
            mul_en_out_reg <= mul_en_out_reg;
        end
    end
end

// Stage 2 & 3: Partial Product Generation and Sum Calculation
reg [2:0] counter;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        partial_product_reg <= 16'd0;
    end else if (mul_en_out_reg) begin
        if (counter == 3'd7) begin
            final_product_reg <= partial_product_reg;
            counter <= 3'd0;
            partial_product_reg <= 16'd0;
        end else begin
            if (mul_b_reg[counter]) begin
                partial_product_reg <= partial_product_reg + ({8'd0, mul_a_reg} << counter);
            end
            counter <= counter + 1'b1;
        end
    end
end

// Stage 4: Output
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? final_product_reg : 16'd0;

endmodule