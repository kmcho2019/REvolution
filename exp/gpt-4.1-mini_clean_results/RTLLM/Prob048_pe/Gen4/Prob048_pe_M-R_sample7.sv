module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Compute product combinationally
    wire [63:0] product = a * b;

    // 64-bit accumulator register
    reg [63:0] accum;

    // Synchronous reset and accumulation on clock edge only
    always @(posedge clk) begin
        if (rst) begin
            accum <= 64'd0;
        end else begin
            accum <= accum + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = accum[31:0];

endmodule