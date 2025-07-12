module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Register to hold the registered product (pipelining stage 1)
    reg [63:0] product_reg;

    // 64-bit accumulator register (stage 2)
    reg [63:0] acc_reg;

    // Perform multiplication combinationally
    wire [63:0] product;
    assign product = a * b;

    // Register the product (pipelining stage 1)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_reg <= 64'b0;
        end else begin
            product_reg <= product;
        end
    end

    // Accumulate the registered product (pipelining stage 2)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_reg <= 64'b0;
        end else begin
            acc_reg <= acc_reg + product_reg;
        end
    end

    // Output the lower 32 bits of accumulator as accumulated result
    assign c = acc_reg[31:0];

endmodule