module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [31:0] product_low;

    // Stage 1: Calculate lower 32 bits of product on each clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_low <= 32'b0;
        end else begin
            product_low <= a * b;
        end
    end

    // Stage 2: Accumulate product_low into c
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= c + product_low;
        end
    end

endmodule