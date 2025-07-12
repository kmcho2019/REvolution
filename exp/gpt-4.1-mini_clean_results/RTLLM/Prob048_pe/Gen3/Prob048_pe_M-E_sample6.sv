module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Register to store product (pipeline stage 1)
    reg [63:0] product_reg;

    // Accumulator register (pipeline stage 2)
    reg [63:0] acc;

    // Combinational multiplication
    wire [63:0] product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_reg <= 64'd0;
            acc <= 64'd0;
        end else begin
            product_reg <= product;     // Stage 1: latch multiplication result
            acc <= acc + product_reg;   // Stage 2: accumulate previous product
        end
    end

    // Output lower 32 bits of accumulated value
    assign c = acc[31:0];

endmodule