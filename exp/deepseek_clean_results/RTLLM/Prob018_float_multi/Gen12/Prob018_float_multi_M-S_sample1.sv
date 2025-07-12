module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Stage 1: Input processing
    reg [31:0] a_reg, b_reg;
    reg sign_reg;
    reg [7:0] exp_sum;
    reg [23:0] a_mantissa, b_mantissa;
    reg special_case;

    // Stage 2: Multiplication
    reg [47:0] product;

    // Stage 3: Normalization and output
    reg [22:0] final_mantissa;
    reg [7:0] final_exponent;
    reg final_sign;

    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
            a_reg <= 0;
            b_reg <= 0;
            product <= 0;
        end else begin
            // Stage 1: Input processing
            a_reg <= a;
            b_reg <= b;
            
            // Extract components
            sign_reg <= a[31] ^ b[31];
            a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            exp_sum <= a[30:23] + b[30:23] - 127;
            
            // Special case detection
            special_case <= (&a[30:23] || &b[30:23] || 
                           ((a[30:23] == 0) && (a[22:0] == 0) || 
                           ((b[30:23] == 0) && (b[22:0] == 0));

            // Stage 2: Multiplication
            product <= a_mantissa * b_mantissa;

            // Stage 3: Normalization and output
            if (special_case) begin
                // Handle special cases (NaN, Inf, Zero)
                if ((&a_reg[30:23] && (a_reg[22:0] != 0)) || 
                    (&b_reg[30:23] && (b_reg[22:0] != 0)) ||
                    (&a_reg[30:23] && (&b_reg[30:23] == 0) ||
                    (&b_reg[30:23] && (&a_reg[30:23] == 0))) begin
                    z <= {sign_reg, 8'hFF, 1'b1, 22'b0}; // NaN
                end else if (&a_reg[30:23] || &b_reg[30:23]) begin
                    z <= {sign_reg, 8'hFF, 23'b0}; // Inf
                end else begin
                    z <= {sign_reg, 31'b0}; // Zero
                end
            end else begin
                // Normal case
                if (product[47]) begin
                    final_mantissa <= product[46:24] + product[23];
                    final_exponent <= exp_sum + 1;
                end else begin
                    final_mantissa <= product[45:23] + product[22];
                    final_exponent <= exp_sum;
                end
                final_sign <= sign_reg;

                // Handle overflow/underflow
                if (&final_exponent[7:0] || final_exponent[7]&!final_exponent[6]) begin
                    z <= {final_sign, 8'hFF, 23'b0}; // Overflow -> Inf
                end else if (final_exponent[7]) begin
                    z <= {final_sign, 31'b0}; // Underflow -> Zero
                end else begin
                    z <= {final_sign, final_exponent[7:0], final_mantissa[22:0]};
                end
            end
        end
    end

endmodule