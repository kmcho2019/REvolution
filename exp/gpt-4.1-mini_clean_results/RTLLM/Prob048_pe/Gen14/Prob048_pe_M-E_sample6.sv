module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] accumulator;
    wire [63:0] product;

    // Multiply operands
    assign product = a * b;

    // Accumulate product into 64-bit register with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = accumulator[31:0];

endmodule