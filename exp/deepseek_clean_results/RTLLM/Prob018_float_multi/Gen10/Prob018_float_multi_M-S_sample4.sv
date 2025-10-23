module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline counter
    reg [1:0] stage;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_s, b_s;
    
    reg [47:0] product;
    reg [8:0] exp_sum;
    reg sign_inter;
    
    reg [22:0] z_mantissa;
    reg [7:0] z_exponent;
    reg z_sign;

    // Special case detection
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 1: Input processing
                    a_s <= a_sign;
                    b_s <= b_sign;
                    a_exponent <= a_exp;
                    b_exponent <= b_exp;
                    a_mantissa <= (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
                    b_mantissa <= (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};
                    stage <= 1;
                end
                
                1: begin  // Stage 2: Multiplication and exponent calculation
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
                    sign_inter <= a_s ^ b_s;
                    stage <= 2;
                end
                
                2: begin  // Stage 3: Normalization, rounding, and output
                    // Normalization
                    if (product[47]) begin
                        z_mantissa <= product[46:24] + (product[23] & (product[22] | |product[21:0]));
                        z_exponent <= exp_sum[7:0] + 1;
                    end else begin
                        z_mantissa <= product[45:23] + (product[22] & (product[21] | |product[20:0]));
                        z_exponent <= exp_sum[7:0];
                    end
                    z_sign <= sign_inter;
                    
                    // Output selection with priority
                    if (a_nan || b_nan) z <= 32'h7FC00000;
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) z <= 32'h7FC00000;
                    else if (a_inf || b_inf) z <= {sign_inter, 8'hFF, 23'b0};
                    else if (a_zero || b_zero) z <= {sign_inter, 31'b0};
                    else if (exp_sum[8] || (&exp_sum[7:0])) z <= {sign_inter, 8'hFF, 23'b0}; // Overflow
                    else if (exp_sum == 0) z <= {sign_inter, 31'b0}; // Underflow
                    else z <= {sign_inter, z_exponent, z_mantissa[22:0]};
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule