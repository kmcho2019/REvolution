module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;        // 64-bit accumulator for full precision accumulation
    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule