module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage counter
    reg [1:0] stage;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detection (combinational)
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg sign_inter;
    
    reg [47:0] product;
    reg [8:0] exp_sum;
    reg sign_reg;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_reg, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_reg, 31'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 1: Input decomposition and special cases
                    sign_inter <= a_sign ^ b_sign;
                    
                    if (special_case) begin
                        // Handle special cases immediately
                        if (a_nan || b_nan) z <= nan_out;
                        else if ((a_inf || b_inf) && (a_zero || b_zero)) z <= nan_out;
                        else if (a_inf || b_inf) z <= inf_out;
                        else if (a_zero || b_zero) z <= zero_out;
                        stage <= 0;
                    end else begin
                        // Normal processing
                        a_exponent <= a_exp;
                        b_exponent <= b_exp;
                        a_mantissa <= {1'b1, a_frac};
                        b_mantissa <= {1'b1, b_frac};
                        stage <= 1;
                    end
                end
                
                1: begin  // Stage 2: Multiplication and exponent calculation
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
                    sign_reg <= sign_inter;
                    stage <= 2;
                end
                
                2: begin  // Stage 3: Normalization, rounding and output
                    // Normalization
                    if (product[47]) begin
                        product <= product >> 1;
                        exp_sum <= exp_sum + 1;
                    end
                    
                    // Rounding (guard, round, sticky)
                    if (product[22] && (product[21] || |product[20:0] || product[23])) begin
                        product[47:23] <= product[47:23] + 1;
                        if (product[47:23] == {24{1'b1}}) begin // Overflow
                            product[47:23] <= {1'b1, 23'b0};
                            exp_sum <= exp_sum + 1;
                        end
                    end
                    
                    // Output
                    if (exp_sum[8] || (exp_sum[7:0] == 8'hFF)) begin // Overflow
                        z <= inf_out;
                    end else if (exp_sum == 0) begin // Underflow
                        z <= zero_out;
                    end else begin
                        z <= {sign_reg, exp_sum[7:0], product[46:24]};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule