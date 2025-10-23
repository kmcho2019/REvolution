module pe (
    input           clk,
    input           rst,
    input           en,         // enable accumulation
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Register the multiplier output to break the combinational path
    reg [63:0] mult_reg;
    wire [63:0] product = a * b;

    // 64-bit accumulator register to hold full precision accumulation
    reg [63:0] acc_reg;

    always @(posedge clk) begin
        if (rst) begin
            mult_reg <= 64'd0;
            acc_reg  <= 64'd0;
        end else begin
            mult_reg <= product;
            if (en) begin
                acc_reg <= acc_reg + mult_reg;
            end
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = acc_reg[31:0];

endmodule