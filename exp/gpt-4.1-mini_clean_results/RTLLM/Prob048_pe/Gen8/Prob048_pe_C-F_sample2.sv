module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit accumulator to hold full precision result
    reg [63:0] accumulator;

    // 64-bit product of inputs
    wire [63:0] product = a * b;

    // Output lower 32 bits of accumulator as per specification
    assign c = accumulator[31:0];

    // Synchronous reset and accumulation
    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product;
        end
    end

endmodule