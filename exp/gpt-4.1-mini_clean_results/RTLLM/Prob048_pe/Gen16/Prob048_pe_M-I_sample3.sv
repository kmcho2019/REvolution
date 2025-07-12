module pe (
    input           clk,
    input           rst,        // synchronous reset, active high
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Pipeline stage 1 registers
    reg [31:0] a_reg, b_reg;
    reg        valid_reg;      // could be used to qualify valid multiplication if needed

    // Registered product output (stage 2 input)
    reg [63:0] product_reg;

    // Stage 1: register inputs and compute product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            valid_reg <= 1'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            valid_reg <= 1'b1;
        end
    end

    // Combinational multiplication of registered inputs
    wire [63:0] product_wire = a_reg * b_reg;

    // Stage 2: register the product and accumulate
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
            c <= 32'd0;
        end else begin
            product_reg <= product_wire;

            // Accumulate lower 32 bits of product into c
            c <= c + product_reg[31:0];
        end
    end

endmodule