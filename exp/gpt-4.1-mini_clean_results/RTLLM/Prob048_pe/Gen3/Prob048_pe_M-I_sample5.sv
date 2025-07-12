module pe (
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output wire [31:0]  c
);

    // Pipeline stage 1: product register
    reg [63:0] product_reg;
    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
        end else begin
            product_reg <= product;
        end
    end

    // Pipeline stage 2: accumulator register widened to 64 bits
    reg [63:0] accumulator;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'b0;
        end else begin
            accumulator <= accumulator + product_reg;
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = accumulator[31:0];

endmodule