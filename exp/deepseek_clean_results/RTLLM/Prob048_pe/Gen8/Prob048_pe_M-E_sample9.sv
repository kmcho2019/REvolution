module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg [31:0] accum_reg;

    // Zero detection flags
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire skip_mult = a_zero | b_zero;

    // Stage 1: Operand registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            // Skip multiplication when either input is zero
            product_reg <= skip_mult ? 64'b0 : a * b;
        end
    end

    // Stage 2: Carry-save accumulation
    wire [31:0] sum_lo = accum_reg[31:0] + product_reg[31:0];
    wire [31:0] sum_hi = accum_reg[63:32] + product_reg[63:32] + sum_lo[32];

    always @(posedge clk) begin
        if (rst) begin
            accum_reg <= 64'b0;
            c <= 32'b0;
        end else begin
            // Full precision accumulation (comment out for 32-bit mode)
            accum_reg <= {sum_hi, sum_lo[31:0]};
            
            // Truncated output (32-bit mode)
            c <= sum_lo[31:0];
            
            /* Alternative: Configurable precision mode
            if (precision_mode) begin
                accum_reg <= {sum_hi, sum_lo[31:0]};
                c <= sum_hi[7:0];  // Upper bits for higher precision
            end else begin
                accum_reg <= {32'b0, sum_lo[31:0]};
                c <= sum_lo[31:0];
            end
            */
        end
    end

endmodule