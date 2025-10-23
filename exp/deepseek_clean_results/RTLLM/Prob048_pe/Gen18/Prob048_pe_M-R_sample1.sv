module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] truncated_product;
    wire signed [31:0] accumulated_sum;

    // Combinational logic
    assign product = a * b;
    assign truncated_product = product[31:0];  // Keep only lower 32 bits
    assign accumulated_sum = c + truncated_product;

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= accumulated_sum;
        end
    end

endmodule