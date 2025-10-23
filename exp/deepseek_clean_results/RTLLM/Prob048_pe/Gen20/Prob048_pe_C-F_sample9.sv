module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Full precision multiplication result
    wire signed [63:0] product = a * b;
    wire signed [31:0] product_truncated = product[31:0];
    wire signed [31:0] next_c = c + product_truncated;

    // Registered accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;
        end else begin
            c <= next_c;
        end
    end

endmodule