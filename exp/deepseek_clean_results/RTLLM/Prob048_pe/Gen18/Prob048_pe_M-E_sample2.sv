module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Segment inputs into high and low 16-bit parts
    wire signed [15:0] a_hi = a[31:16];
    wire signed [15:0] a_lo = a[15:0];
    wire signed [15:0] b_hi = b[31:16];
    wire signed [15:0] b_lo = b[15:0];

    // Compute partial products
    wire signed [31:0] p_hi = a_hi * b_hi;
    wire signed [31:0] p_mid1 = a_hi * b_lo;
    wire signed [31:0] p_mid2 = a_lo * b_hi;
    wire signed [31:0] p_lo = a_lo * b_lo;

    // Dynamic scaling detection
    wire a_small = (a_hi == 16'd0) || (a_hi == -16'd1);
    wire b_small = (b_hi == 16'd0) || (b_hi == -16'd1);
    wire use_simple = a_small & b_small;

    // Intermediate accumulation
    reg signed [31:0] accum;
    wire signed [31:0] full_product = 
        (p_hi << 32) + (p_mid1 << 16) + (p_mid2 << 16) + p_lo;
    wire signed [31:0] simple_product = p_lo;

    // Clock gating control
    wire clk_en = ~rst & (|a | |b);
    wire gated_clk;
    assign gated_clk = clk & clk_en;

    // Final accumulation
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
            accum <= 32'd0;
        end else begin
            if (use_simple) begin
                accum <= accum + simple_product;
            end else begin
                accum <= accum + full_product[31:0];
            end
            c <= accum;
        end
    end

    // Overflow detection (optional)
    // wire overflow = (full_product[63:32] != {32{full_product[31]}});

endmodule