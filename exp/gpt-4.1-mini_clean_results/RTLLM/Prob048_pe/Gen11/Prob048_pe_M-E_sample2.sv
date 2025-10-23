module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    // Internal registers for accumulator split into high and low 32-bit parts
    reg [31:0] acc_low;
    reg [31:0] acc_high;

    // 64-bit product of inputs
    wire [63:0] product;

    assign product = a * b;
    assign c = acc_low;  // output the lower 32 bits of accumulator

    always @(posedge clk) begin
        if (rst) begin
            acc_low  <= 32'd0;
            acc_high <= 32'd0;
        end else begin
            // Add product low to acc_low with carry out
            {acc_high, acc_low} <= {acc_high, acc_low} + product;
        end
    end

endmodule