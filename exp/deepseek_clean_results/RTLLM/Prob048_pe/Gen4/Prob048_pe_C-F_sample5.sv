module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] accum_reg;

    // Stage 1: Multiplication
    wire signed [63:0] product_next = a_reg * b_reg;

    // Stage 2: Accumulation
    wire signed [31:0] accum_next = accum_reg + product_reg[31:0];

    always @(posedge clk) begin
        if (rst) begin
            // Clear all pipeline registers
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
            accum_reg <= 32'b0;
            c <= 32'b0;
        end else begin
            // Pipeline stage 1: Register inputs and multiply
            a_reg <= a;
            b_reg <= b;
            product_reg <= product_next;
            
            // Pipeline stage 2: Accumulate
            accum_reg <= accum_next;
            
            // Output the accumulated result
            c <= accum_next;
        end
    end

endmodule