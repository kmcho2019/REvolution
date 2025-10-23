module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [63:0] accumulator;
    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product;
        end
    end

    always @(posedge clk) begin
        c <= accumulator[31:0];
    end

endmodule