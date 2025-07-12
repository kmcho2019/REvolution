module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];
    
    // Normalized mantissas with implicit bit
    wire [23:0] a_mant = (a_exp != 0) ? {1'b1, a_man} : {1'b0, a_man};
    wire [23:0] b_mant = (b_exp != 0) ? {1'b1, b_man} : {1'b0, b_man};
    
    // Special case detection (optimized)
    wire a_zero = (a_exp == 0) && (a_man == 0);
    wire b_zero = (b_exp == 0) && (b_man == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_man == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_man == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_man != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_man != 0);
    
    // Multiplication core (24x24 bits)
    wire [47:0] product = a_mant * b_mant;
    
    // Exponent calculation (optimized)
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp};
    wire [8:0] exp_adj = exp_sum - 9'd127;
    wire norm_shift = product[47];
    wire [8:0] final_exp = norm_shift ? exp_adj + 1 : exp_adj;
    
    // Mantissa normalization and rounding
    wire [22:0] final_mantissa = norm_shift ? product[46:24] : product[45:23];
    
    // Overflow/underflow detection
    wire overflow = (&final_exp[7:0]) || (final_exp[8]);
    wire underflow = (final_exp[8] && ~final_exp[7:0]);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Priority-encoded special cases
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000; // NaN
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z <= 32'h7FC00000; // NaN (0*inf)
            end else if (a_inf || b_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else if (a_zero || b_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else if (overflow) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Overflow -> Inf
            end else if (underflow) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Underflow -> 0
            end else begin
                z <= {a_sign ^ b_sign, final_exp[7:0], final_mantissa};
            end
        end
    end

endmodule