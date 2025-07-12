module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipelined multiplier (2-stage)
    reg signed [31:0] a_reg, b_reg;
    wire signed [63:0] product = a_reg * b_reg;

    // Clock gating control
    wire accum_enable = ~rst;

    // Operand isolation
    wire signed [31:0] a_iso = rst ? 32'sb0 : a;
    wire signed [31:0] b_iso = rst ? 32'sb0 : b;

    // Pipeline stage 1: Input registers
    always @(posedge clk) begin
        a_reg <= a_iso;
        b_reg <= b_iso;
    end

    // Pipeline stage 2: Accumulation with clock gating
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;  // Synchronous reset
        end else if (accum_enable) begin
            // Note: Product is truncated to 32 bits
            // Overflow behavior: Wraparound (document this)
            c <= c + product[31:0];
        end
    end

endmodule