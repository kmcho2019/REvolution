module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal signals
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exponent = a[30:23];
    wire [7:0] b_exponent = b[30:23];
    wire [22:0] a_mantissa = a[22:0];
    wire [22:0] b_mantissa = b[22:0];
    
    // Special case detection
    wire a_zero = (a_exponent == 0) && (a_mantissa == 0);
    wire b_zero = (b_exponent == 0) && (b_mantissa == 0);
    wire a_inf = (a_exponent == 8'hFF) && (a_mantissa == 0);
    wire b_inf = (b_exponent == 8'hFF) && (b_mantissa == 0);
    wire a_nan = (a_exponent == 8'hFF) && (a_mantissa != 0);
    wire b_nan = (b_exponent == 8'hFF) && (b_mantissa != 0);
    
    // Normalized mantissas with implicit bit
    wire [23:0] a_mant_norm = (a_exponent != 0) ? {1'b1, a_mantissa} : {1'b0, a_mantissa};
    wire [23:0] b_mant_norm = (b_exponent != 0) ? {1'b1, b_mantissa} : {1'b0, b_mantissa};
    
    // Multiply mantissas (48-bit result)
    wire [47:0] product = a_mant_norm * b_mant_norm;
    
    // Calculate exponent (with bias adjustment)
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent};
    wire [8:0] exp_adj = exp_sum - 9'd127;
    
    // Normalization and rounding
    wire norm_shift = product[47]; // Check if product needs normalization
    wire [22:0] final_mantissa = norm_shift ? product[46:24] : product[45:23];
    wire [8:0] final_exponent = norm_shift ? exp_adj + 1 : exp_adj;
    
    // Special case handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000; // NaN
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z <= 32'h7FC00000; // NaN (0*inf)
            end else if (a_inf || b_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else if (a_zero || b_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else if (final_exponent[8] || (&final_exponent[7:0])) begin // Overflow/underflow
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else begin
                z <= {a_sign ^ b_sign, final_exponent[7:0], final_mantissa};
            end
        end
    end

endmodule