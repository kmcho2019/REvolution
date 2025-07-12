module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] acc_reg;

    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] accum_in;

    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Combinational multiplication (isolated during reset)
    assign product = rst ? 64'd0 : a_reg * b_reg;

    // Stage 2: Product registration and accumulation
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
            acc_reg <= 32'd0;
        end else begin
            product_reg <= product;
            acc_reg <= acc_reg + product_reg[31:0];
        end
    end

    // Output assignment
    assign c = acc_reg;

endmodule