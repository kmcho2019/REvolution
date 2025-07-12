module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Registered inputs to improve timing
    reg signed [31:0] a_reg, b_reg;
    wire signed [31:0] product;
    reg signed [31:0] product_reg;
    reg signed [31:0] acc_reg;
    
    // Clock gating control
    wire inputs_zero = (a == 0) && (b == 0);
    wire clk_en = ~rst & ~inputs_zero;

    // Output assignment
    assign c = acc_reg;

    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            product_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= product;
        end
    end

    // Combinational multiplication (only lower 32 bits)
    assign product = a_reg * b_reg;

    // Stage 2: Accumulation with clock gating
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 0;
        end else if (clk_en) begin
            acc_reg <= acc_reg + product_reg;
        end
    end

endmodule