module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg special_case;
    reg [47:0] partial_product [2:0];
    reg [9:0] exp_sum;
    reg sign_result;
    
    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0;
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Early special case detection
    wire is_special = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Wallace tree partial products
    wire [47:0] pp0, pp1, pp2;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing
                    a_sign <= a[31];
                    b_sign <= b[31];
                    sign_result <= a[31] ^ b[31];
                    
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    exp_sum <= {2'b0, a[30:23]} + {2'b0, b[30:23]} - 8'd127;
                    
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    special_case <= is_special;
                    
                    // Generate first set of partial products
                    partial_product[0] <= a_mantissa * b_mantissa[7:0];
                    partial_product[1] <= a_mantissa * b_mantissa[15:8];
                    partial_product[2] <= a_mantissa * b_mantissa[23:16];
                    
                    stage <= 1;
                end
                
                1: begin // Stage 1: Wallace tree reduction (first level)
                    // First level compression
                    pp0 <= partial_product[0] + (partial_product[1] << 8);
                    pp1 <= partial_product[2] << 16;
                    
                    stage <= 2;
                end
                
                2: begin // Stage 2: Final addition and normalization
                    if (special_case) begin
                        // Handle special cases
                        if (a_nan | b_nan) z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // NaN
                        else if ((a_inf & b_zero) | (b_inf & a_zero)) z <= {sign_result, 8'hFF, 1'b1, 22'b0}; // NaN
                        else if (a_inf | b_inf) z <= {sign_result, 8'hFF, 23'b0}; // Infinity
                        else z <= {sign_result, 31'b0}; // Zero
                    end else begin
                        // Final addition
                        reg [47:0] product = pp0 + pp1;
                        
                        // Normalization and rounding
                        reg [22:0] mantissa;
                        reg [7:0] exponent = exp_sum[7:0];
                        
                        if (product[47]) begin // >= 2.0
                            mantissa = product[46:24] + (product[23] & (product[22] | |product[21:0]));
                            exponent = exponent + 1;
                        end else begin // < 2.0
                            mantissa = product[45:23] + (product[22] & (product[21] | |product[20:0]));
                        end
                        
                        // Handle overflow/underflow
                        if (&exponent | (exp_sum > 10'd254)) begin // Overflow
                            z <= {sign_result, 8'hFF, 23'b0};
                        end else if (exp_sum[9] | (exp_sum == 0)) begin // Underflow
                            z <= {sign_result, 31'b0};
                        end else begin
                            z <= {sign_result, exponent, mantissa};
                        end
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule