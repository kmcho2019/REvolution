module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

// Registers for inputs and enable
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg   <= 8'd0;
        mul_b_reg   <= 8'd0;
        mul_en_reg  <= 1'b0;
        mul_en_out  <= 1'b0;
        mul_out     <= 16'd0;
    end else begin
        // Register inputs and enable
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Output enable delayed by one clock cycle
        mul_en_out <= mul_en_reg;

        // Compute product combinationally from registered inputs
        mul_out <= mul_en_reg ? (mul_a_reg * mul_b_reg) : 16'd0;
    end
end

endmodule