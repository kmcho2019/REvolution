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
reg [15:0] product;

always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        product <= 16'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Initialize product
        product <= 16'b0;

        // Multiply and accumulate
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i])
                product <= product + (mul_a_reg << i);
        end

        // Output enable signal
        mul_en_out <= mul_en_in;

        // Output assignment
        if (mul_en_in)
            mul_out <= product;
        else
            mul_out <= 16'b0;
    end
end

endmodule