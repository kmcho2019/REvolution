module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [63:0] product_reg;
    reg signed [31:0] c_reg;

    // Stage 1: Multiplication (combinational)
    wire signed [63:0] product = a * b;

    // Stage 2: Accumulation (sequential)
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
            c <= 32'b0;
        end else begin
            // Register multiplication result
            product_reg <= product;
            
            // Accumulate with 32-bit truncation
            c <= c + product_reg[31:0];
        end
    end

endmodule