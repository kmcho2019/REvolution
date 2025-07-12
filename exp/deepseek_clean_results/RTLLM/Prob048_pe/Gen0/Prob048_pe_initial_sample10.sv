module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal 64-bit product to prevent overflow during multiplication
    wire signed [63:0] product;
    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset
            c <= 32'd0;
        end else begin
            // Accumulate with proper sign extension and overflow handling
            // We truncate to 32 bits (saturating arithmetic would be alternative)
            c <= c + product[31:0];
        end
    end

endmodule