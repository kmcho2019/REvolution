module pe (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power optimization
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] partial_prod [15:0]; // Partial products
    reg signed [31:0] stage1_result;
    
    // Final product (only need 32 bits)
    wire signed [31:0] product;

    // Stage 1: Partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            for (int i = 0; i < 16; i = i + 1)
                partial_prod[i] <= 32'd0;
        end else if (en) begin
            a_reg <= a;
            b_reg <= b;
            // Generate partial products (simplified for illustration)
            for (int i = 0; i < 16; i = i + 1)
                partial_prod[i] <= a[(2*i)+:2] * b[(2*i)+:2];
        end
    end

    // Stage 2: Final addition (carry-save style)
    always @(posedge clk) begin
        if (rst) begin
            stage1_result <= 32'd0;
        end else if (en) begin
            // Simplified carry-save addition of partial products
            stage1_result <= partial_prod[0] + partial_prod[1] + ... + partial_prod[15];
        end
    end

    assign product = stage1_result;

    // Accumulation stage
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (en) begin
            c <= c + product;
        end
    end

endmodule