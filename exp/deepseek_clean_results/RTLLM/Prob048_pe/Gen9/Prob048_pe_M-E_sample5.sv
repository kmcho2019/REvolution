module pe (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power saving
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg [31:0] accum_reg;
    
    // Split into 16-bit chunks for Karatsuba multiplication
    wire [15:0] a_hi = a[31:16];
    wire [15:0] a_lo = a[15:0];
    wire [15:0] b_hi = b[31:16];
    wire [15:0] b_lo = b[15:0];
    
    // Partial products
    wire [31:0] p_hi = a_hi * b_hi;
    wire [31:0] p_lo = a_lo * b_lo;
    wire [31:0] p_mid = (a_hi + a_lo) * (b_hi + b_lo);
    
    // Full product calculation (Karatsuba)
    wire [63:0] product = {p_hi, 32'b0} + {p_mid - p_hi - p_lo, 16'b0} + p_lo;
    
    // Overflow detection
    wire overflow_pos = (accum_reg[31] == 0) && (product_reg[63:32] != 0) && 
                       ((accum_reg + product_reg[31:0])[31] == 1);
    wire overflow_neg = (accum_reg[31] == 1) && (product_reg[63:32] != 64'hFFFFFFFF) && 
                       ((accum_reg + product_reg[31:0])[31] == 0);
    
    // Saturated result
    wire [31:0] saturated_result = overflow_pos ? 32'h7FFFFFFF :
                                 overflow_neg ? 32'h80000000 :
                                 accum_reg + product_reg[31:0];

    // Pipeline stage 1: Register inputs and compute product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
        end else if (en) begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= product;
        end
    end

    // Pipeline stage 2: Accumulate with saturation
    always @(posedge clk) begin
        if (rst) begin
            accum_reg <= 32'b0;
            c <= 32'b0;
        end else if (en) begin
            accum_reg <= saturated_result;
            c <= saturated_result;
        end
    end

endmodule