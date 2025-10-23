module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit register to hold accumulated sum of 32x32 products
    reg [63:0] acc;

    // Combinational 64-bit product of inputs
    wire [63:0] product = a * b;

    // Synchronous reset and accumulation on positive clock edge
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule