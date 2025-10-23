module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [63:0] acc;        // 64-bit accumulator to hold full accumulation
    wire [63:0] product;    // full 64-bit product of a and b

    assign product = a * b;

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