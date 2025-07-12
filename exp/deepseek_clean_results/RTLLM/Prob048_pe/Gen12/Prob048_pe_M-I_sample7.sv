module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c,
    output wire overflow
);

    // Registered inputs for better timing
    reg signed [31:0] a_reg, b_reg;
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
    end

    // Clock gating for multiplier
    wire mult_clk_en = ~rst;
    wire gated_clk;
    assign gated_clk = clk & mult_clk_en;

    // Pipeline stage 1: Multiplication
    reg signed [63:0] product_reg;
    always @(posedge gated_clk) begin
        product_reg <= a_reg * b_reg;
    end

    // Pipeline stage 2: Accumulation with overflow detection
    wire signed [63:0] next_c = { {32{c[31]}}, c } + product_reg;
    assign overflow = (next_c[63:32] != {32{next_c[31]}}); // Detect overflow

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= next_c[31:0]; // Truncate to 32 bits
        end
    end

endmodule