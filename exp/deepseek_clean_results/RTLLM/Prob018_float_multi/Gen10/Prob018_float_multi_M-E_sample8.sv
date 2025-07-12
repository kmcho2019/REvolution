module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg sign_p1, sign_p2, sign_p3;
    reg [7:0] exp_sum_p1, exp_sum_p2;
    reg [47:0] product_p1, product_p2;
    reg special_case_p1, special_case_p2;
    reg [2:0] rounding_bits_p2;

    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Stage 0: Input registration and initial processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            case (stage)
                0: begin
                    // Register inputs
                    a_reg <= a;
                    b_reg <= b;
                    
                    // Process sign and exponent in parallel
                    sign_p1 <= a[31] ^ b[31];
                    exp_sum_p1 <= {1'b0, a[30:23]} + {1'b0, b[30:23]} - 8'd127;
                    
                    // Detect special cases early
                    special_case_p1 <= special_case;
                    
                    // Start multiplication with implicit 1
                    product_p1 <= {1'b1, a[22:0]} * {1'b1, b[22:0]};
                    
                    stage <= 1;
                end
                
                1: begin
                    // Normalize product (shift if MSB is 1)
                    if (product_p1[47]) begin
                        product_p2 <= product_p1;
                        exp_sum_p2 <= exp_sum_p1 + 1;
                    end else begin
                        product_p2 <= product_p1 << 1;
                        exp_sum_p2 <= exp_sum_p1;
                    end
                    
                    // Prepare rounding bits
                    rounding_bits_p2 <= {product_p1[22], product_p1[21], |product_p1[20:0]};
                    
                    // Pipeline other signals
                    sign_p2 <= sign_p1;
                    special_case_p2 <= special_case_p1;
                    
                    stage <= 2;
                end
                
                2: begin
                    // Rounding using carry-save technique
                    wire [24:0] rounded_mantissa = {1'b0, product_p2[46:23]} + 
                                                  {23'b0, rounding_bits_p2[2] & 
                                                  (rounding_bits_p2[1] | rounding_bits_p2[0] | product_p2[23])};
                    
                    // Final exponent adjustment if rounding overflow
                    wire [7:0] final_exp = rounded_mantissa[24] ? exp_sum_p2 + 1 : exp_sum_p2;
                    
                    // Handle all cases
                    if (special_case_p2) begin
                        if (a_nan | b_nan) z <= 32'h7FC00000;
                        else if (a_inf | b_inf) begin
                            if (a_zero | b_zero) z <= 32'h7FC00000;
                            else z <= {sign_p2, 8'hFF, 23'b0};
                        end
                        else z <= {sign_p2, 31'b0}; // zero case
                    end
                    else if (final_exp[7] & ~final_exp[6]) begin // overflow
                        z <= {sign_p2, 8'hFF, 23'b0};
                    end
                    else if (~final_exp[7] & final_exp[6]) begin // underflow
                        z <= {sign_p2, 31'b0};
                    end
                    else begin // normal case
                        z <= {sign_p2, final_exp[6:0], rounded_mantissa[22:0]};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule