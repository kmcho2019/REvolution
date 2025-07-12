module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // 64-bit product of a and b
    wire [63:0] product = a * b;

    // 64-bit accumulator register to prevent overflow in accumulation
    reg [63:0] accum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 64'd0;
        end else begin
            accum <= accum + product;
        end
    end

    // Output the lower 32 bits of the accumulator as required
    assign c = accum[31:0];

endmodule