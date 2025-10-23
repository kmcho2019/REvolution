module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc64;
    wire [63:0] product;

    // Multiply inputs: 32x32 -> 64 bits
    assign product = a * b;

    // Output is lower 32 bits of accumulator
    assign c = acc64[31:0];

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc64 <= 64'd0;
        end else begin
            acc64 <= acc64 + product;
        end
    end

endmodule