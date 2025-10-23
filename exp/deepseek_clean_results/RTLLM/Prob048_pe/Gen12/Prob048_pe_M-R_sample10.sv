module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    reg signed [31:0] product;
    reg signed [31:0] sum;

    always @(*) begin
        // Direct multiplication with explicit 32-bit truncation
        product = a * b;
        // Accumulation path
        sum = c + product;
    end

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= sum;
        end
    end

endmodule