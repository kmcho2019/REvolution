module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

    // Input registers for operands and enable
    reg [7:0] mul_a_reg, mul_b_reg;
    reg       mul_en_reg;

    // Registered product
    reg [15:0] product_reg;

    // Register inputs and enable on clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg    <= 8'd0;
            mul_b_reg    <= 8'd0;
            mul_en_reg   <= 1'b0;
            product_reg  <= 16'd0;
            mul_en_out   <= 1'b0;
            mul_out      <= 16'd0;
        end else begin
            mul_en_reg <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            product_reg <= mul_a_reg * mul_b_reg;
            mul_en_out  <= mul_en_reg;
            mul_out     <= mul_en_out ? product_reg : 16'd0;
        end
    end

endmodule