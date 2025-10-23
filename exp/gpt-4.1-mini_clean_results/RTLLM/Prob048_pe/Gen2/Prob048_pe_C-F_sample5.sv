module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit accumulator register to hold full precision result
    reg [63:0] acc;

    // 64-bit product of inputs
    wire [63:0] product = a * b;

    // Synchronous reset and accumulation
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output is lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule