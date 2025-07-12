module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Combinational multiplier
    wire signed [63:0] product;
    assign product = a * b;

    // Sequential accumulator
    reg signed [31:0] next_c;

    always @(*) begin
        if (rst) begin
            next_c = 32'sd0;
        end else begin
            next_c = c + product[31:0];
        end
    end

    always @(posedge clk) begin
        c <= next_c;
    end

endmodule