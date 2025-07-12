module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;            // 64-bit accumulator to avoid overflow
    wire [63:0] product;

    // Unsigned 32x32 multiplication
    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of the accumulator as the result
    assign c = acc[31:0];

endmodule