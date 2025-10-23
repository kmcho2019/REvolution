module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    wire [63:0] product;
    wire        accumulate_en;

    assign product = a * b;
    assign accumulate_en = 1'b1;  // Always enable accumulation for this design
    assign c = accumulator[31:0]; // Output lower 32 bits of accumulator

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else if (accumulate_en) begin
            accumulator <= accumulator + product;
        end
    end

endmodule