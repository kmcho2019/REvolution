module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal 64-bit product to handle full multiplication result before truncation
    wire signed [63:0] product;

    // Combinational multiplication
    assign product = a * b;

    // Sequential accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;  // Reset accumulator
        end else begin
            // Accumulate with 32-bit truncation (overflow possible)
            c <= c + product[31:0];
        end
    end

endmodule