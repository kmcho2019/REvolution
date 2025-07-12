module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Enable pipeline registers (2 stages)
    reg mul_en_reg1, mul_en_reg2;

    // Product register
    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_en_reg1 <= 1'b0;
            mul_en_reg2 <= 1'b0;
            mul_out_reg <= 16'b0;
        end else begin
            // Stage 1: sample inputs and enable
            mul_en_reg1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            // Stage 2: compute product and propagate enable
            mul_en_reg2 <= mul_en_reg1;
            if (mul_en_reg1) begin
                mul_out_reg <= mul_a_reg * mul_b_reg;
            end else begin
                mul_out_reg <= 16'b0;
            end
        end
    end

    // Output assignments
    assign mul_en_out = mul_en_reg2;
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule