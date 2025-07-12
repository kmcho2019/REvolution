module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc_64;

    wire [63:0] product;

    // 32x32 multiplier
    assign product = a * b;

    // Accumulate product into 64-bit accumulator with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc_64 <= 64'd0;
        end else begin
            acc_64 <= acc_64 + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc_64[31:0];

endmodule