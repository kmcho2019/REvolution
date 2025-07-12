module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Register to hold product, pipelining multiplication
    reg [63:0] product_reg;
    // 64-bit accumulator register
    reg [63:0] acc;

    // Continuous multiplication
    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
            acc <= 64'b0;
        end else begin
            product_reg <= product;
            acc <= acc + product_reg;
        end
    end

    // Output the lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule