module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    wire [63:0] product;
    wire        accumulate_enable;

    assign product = a * b;
    // Enable accumulation only if neither input is zero (power optimization)
    assign accumulate_enable = |a && |b;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else if (accumulate_enable) begin
            accumulator <= accumulator + product;
        end
        // else maintain accumulator value (no change)
    end

    // Output lower 32 bits of accumulator
    assign c = accumulator[31:0];

endmodule