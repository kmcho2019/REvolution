module pe (
    input wire clk,
    input wire rst,
    input wire precision_mode,  // 0=32-bit, 1=16-bit mode
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c,
    output wire overflow
);

    // Pipeline control signals
    wire zero_input = (a == 32'b0) || (b == 32'b0);
    wire pipeline_enable = ~rst & ~zero_input;

    // Precision-adjusted operands
    wire [31:0] a_adj = precision_mode ? {{16{a[15]}}, a[15:0]} : a;
    wire [31:0] b_adj = precision_mode ? {{16{b[15]}}, b[15:0]} : b;

    // Pipeline stage 1: Multiplication
    reg [63:0] product_reg;
    reg [31:0] a_reg, b_reg;
    wire [63:0] product = a_adj * b_adj;

    // Pipeline stage 2: Accumulation with saturation
    reg [31:0] c_next;
    wire [63:0] sum = {32'b0, c} + product_reg;
    wire overflow_detect = (sum[63:32] != 32'b0) && (sum[63:32] != 32'hFFFFFFFF);

    // Saturation logic
    always @(*) begin
        if (overflow_detect) begin
            c_next = product_reg[63] ? 32'h80000000 : 32'h7FFFFFFF;
        end else begin
            c_next = sum[31:0];
        end
    end

    // Pipeline registers with clock gating
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            c <= 32'b0;
        end else if (pipeline_enable) begin
            // Stage 1
            product_reg <= product;
            a_reg <= a_adj;
            b_reg <= b_adj;
            
            // Stage 2
            c <= c_next;
        end
    end

    assign overflow = overflow_detect;

endmodule