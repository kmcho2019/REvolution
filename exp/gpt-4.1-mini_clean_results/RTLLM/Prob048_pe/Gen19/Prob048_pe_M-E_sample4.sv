module pe (
    input             clk,
    input             rst,        // synchronous active-high reset
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] c           // lower 32 bits of accumulator output
);

    reg [63:0] accumulator;

    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
            c <= 32'd0;
        end else begin
            accumulator <= accumulator + product;
            c <= accumulator[31:0];
        end
    end

endmodule