module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Zero detection for clock gating
    wire inputs_nonzero = |a || |b;
    wire gated_clk = clk & inputs_nonzero;

    // Pipeline stage 1: Lower 16x16 multiplication
    reg [15:0] a_low, b_low;
    reg [31:0] product_low;
    always @(posedge gated_clk) begin
        a_low <= a[15:0];
        b_low <= b[15:0];
        product_low <= a[15:0] * b[15:0];
    end

    // Pipeline stage 2: Upper 16x16 and cross terms
    reg [15:0] a_high, b_high;
    reg [31:0] product_high, product_mid;
    always @(posedge gated_clk) begin
        a_high <= a[31:16];
        b_high <= b[31:16];
        product_high <= a[31:16] * b[31:16];
        product_mid <= (a[31:16] * b_low) + (a_low * b[31:16]);
    end

    // Carry-save accumulator
    reg [31:0] sum, carry;
    wire [31:0] final_product = product_low + (product_mid << 16) + (product_high << 32);
    wire [31:0] next_sum = sum ^ carry ^ final_product[31:0];
    wire [31:0] next_carry = (sum & carry) | (sum & final_product[31:0]) | (carry & final_product[31:0]);

    // Final accumulation with reset
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            sum <= 32'd0;
            carry <= 32'd0;
            c <= 32'd0;
        end else begin
            sum <= next_sum;
            carry <= next_carry << 1;
            // Only propagate carry when needed (every 8 cycles)
            if (&sum[2:0]) begin
                c <= sum + (carry << 1);
            end
        end
    end

endmodule