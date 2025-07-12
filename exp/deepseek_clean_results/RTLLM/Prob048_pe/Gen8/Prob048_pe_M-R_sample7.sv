module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] next_c;

    // Combinational multiplication
    assign product = a * b;

    // Next state logic for accumulator
    assign next_c = rst ? 32'b0 : (c + product[31:0]);

    // Sequential update of accumulator
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule