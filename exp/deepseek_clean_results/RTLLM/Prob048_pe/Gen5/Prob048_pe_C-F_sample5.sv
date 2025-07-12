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
    
    // Internal signals
    wire signed [63:0] product;

    // Stage 1: Input registration (helps timing)
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Stage 2: Multiplication (combinational)
    assign product = a_reg * b_reg;

    // Stage 3: Product registration and accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
            // Accumulate with 32-bit truncation
            c <= c + product_reg[31:0];
        end
    end

endmodule