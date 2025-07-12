module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    wire [63:0] product;
    wire [63:0] sum;

    assign product = a * b;
    assign sum = accumulator + product;
    assign c = accumulator[31:0];  // Output lower 32 bits of accumulator

    always @(posedge clk) begin
        if (rst)
            accumulator <= 64'd0;
        else
            accumulator <= sum;
    end

endmodule