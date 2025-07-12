module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    
    // Special case detection
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    
    // Mantissa with implicit bit
    wire [23:0] a_man = (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_man = (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};
    
    // Multiply mantissas
    wire [47:0] product = a_man * b_man;
    
    // Calculate exponent
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    
    always @(*) begin
        // Handle special cases with priority
        if (a_nan || b_nan) begin
            z = {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
        end
        else if ((a_zero && b_inf) || (a_inf && b_zero)) begin
            z = {1'b0, 8'hFF, 23'h7FFFFF}; // 0*inf = NaN
        end
        else if (a_inf || b_inf) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'h0}; // Infinity
        end
        else if (a_zero || b_zero) begin
            z = {a_sign ^ b_sign, 31'h0}; // Zero
        end
        else begin
            // Normal case
            reg [7:0] z_exp;
            reg [22:0] z_frac;
            
            // Normalize (product is either 01.xxxx or 00.xxxx)
            if (product[47]) begin
                z_frac = product[46:24]; // Take 23 bits after the point
                z_exp = exp_sum[7:0] + 1;
            end
            else begin
                z_frac = product[45:23]; // Shift left by 1
                z_exp = exp_sum[7:0];
            end
            
            // Check for overflow/underflow
            if (exp_sum[8] || (z_exp >= 8'hFF)) begin // Overflow
                z = {a_sign ^ b_sign, 8'hFF, 23'h0};
            end
            else if (z_exp == 0) begin // Underflow
                z = {a_sign ^ b_sign, 31'h0};
            end
            else begin
                z = {a_sign ^ b_sign, z_exp, z_frac};
            end
        end
    end

endmodule