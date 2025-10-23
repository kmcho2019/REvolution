module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [63:0] mult_result;
    reg [63:0] acc;

    // Stage 1: Multiply a and b, register the product
    always @(posedge clk) begin
        if (rst) begin
            mult_result <= 64'b0;
        end else begin
            mult_result <= a * b;
        end
    end

    // Stage 2: Accumulate the registered product
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'b0;
            c <= 32'b0;
        end else begin
            acc <= acc + mult_result;
            c <= acc[31:0];
        end
    end

endmodule