module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Continuous assignment for multiplication
    wire signed [31:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product;  // Direct accumulation
        end
    end

endmodule