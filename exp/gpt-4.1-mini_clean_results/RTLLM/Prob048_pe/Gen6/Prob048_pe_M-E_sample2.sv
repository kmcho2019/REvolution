module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Registers for pipelined product and accumulator
    reg [63:0] product_reg;
    reg [63:0] acc;

    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
            acc <= 64'd0;
        end else begin
            product_reg <= product;
            acc <= acc + product_reg;
        end
    end

    assign c = acc[31:0];

endmodule