module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    // Internal 64-bit accumulator to avoid overflow during accumulation
    reg  [63:0] accumulator;
    wire [63:0] product;

    assign product = a * b;

    // Output the lower 32 bits of the accumulator as required
    assign c = accumulator[31:0];

    // Clock enable for accumulation gating (hardcoded to 1 for always enable)
    // Can be externally connected for power optimization in system
    wire acc_en = 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else if (acc_en) begin
            accumulator <= accumulator + product;
        end
        // else: hold accumulator value to reduce toggling and power
    end

endmodule