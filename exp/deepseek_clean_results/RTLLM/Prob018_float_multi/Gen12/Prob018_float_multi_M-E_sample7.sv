module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [3:0] valid;
    reg [31:0] a_stage1, b_stage1;
    reg [31:0] a_stage2, b_stage2;
    reg [31:0] a_stage3, b_stage3;
    
    // Special case flags
    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    wire special_case;
    reg [1:0] special_case_type; // 00: normal, 01: zero, 10: inf, 11: nan
    
    // Mantissa processing
    reg [23:0] a_mantissa, b_mantissa;
    reg [11:0] a_high, a_low;
    reg [23:0] partial_prod_high, partial_prod_low;
    reg [47:0] product;
    reg [47:0] product_csa_sum, product_csa_carry;
    
    // Exponent processing
    reg [8:0] a_exponent, b_exponent;
    reg [8:0] z_exponent;
    reg exponent_overflow;
    
    // Sign and rounding
    reg z_sign;
    reg [23:0] z_mantissa;
    reg guard_bit, round_bit, sticky;
    wire [23:0] rounded_mantissa;
    
    // Early special case detection (combinational)
    assign a_zero = (a[30:0] == 0);
    assign b_zero = (b[30:0] == 0);
    assign a_inf = (&a[30:23]) && (a[22:0] == 0);
    assign b_inf = (&b[30:23]) && (b[22:0] == 0);
    assign a_nan = (&a[30:23]) && (|a[22:0]);
    assign b_nan = (&b[30:23]) && (|b[22:0]);
    assign special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Pipeline stage 1: Input processing and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 0;
            special_case_type <= 0;
            a_stage1 <= 0;
            b_stage1 <= 0;
        end else begin
            valid[0] <= 1;
            a_stage1 <= a;
            b_stage1 <= b;
            
            // Determine special case type
            if (a_nan || b_nan) begin
                special_case_type <= 2'b11;
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                special_case_type <= 2'b11; // inf*0 = NaN
            end else if (a_inf || b_inf) begin
                special_case_type <= 2'b10;
            end else if (a_zero || b_zero) begin
                special_case_type <= 2'b01;
            end else begin
                special_case_type <= 2'b00;
            end
        end
    end
    
    // Pipeline stage 2: Partial multiplication and exponent handling
    always @(posedge clk) begin
        if (valid[0]) begin
            valid[1] <= 1;
            a_stage2 <= a_stage1;
            b_stage2 <= b_stage1;
            
            // Extract mantissas with implicit bit
            a_mantissa <= (|a_stage1[30:23]) ? {1'b1, a_stage1[22:0]} : {1'b0, a_stage1[22:0]};
            b_mantissa <= (|b_stage1[30:23]) ? {1'b1, b_stage1[22:0]} : {1'b0, b_stage1[22:0]};
            
            // Split multiplier for partial products
            a_high <= a_mantissa[23:12];
            a_low <= a_mantissa[11:0];
            
            // Compute partial products
            partial_prod_high <= a_high * b_mantissa;
            partial_prod_low <= a_low * b_mantissa;
            
            // Exponent handling
            a_exponent <= a_stage1[30:23];
            b_exponent <= b_stage1[30:23];
            z_exponent <= {1'b0, a_stage1[30:23]} + {1'b0, b_stage1[30:23]} - 9'd127;
            z_sign <= a_stage1[31] ^ b_stage1[31];
        end else begin
            valid[1] <= 0;
        end
    end
    
    // Pipeline stage 3: Product accumulation and normalization
    always @(posedge clk) begin
        if (valid[1]) begin
            valid[2] <= 1;
            a_stage3 <= a_stage2;
            b_stage3 <= b_stage2;
            
            // Accumulate partial products using carry-save adder
            product_csa_sum <= (partial_prod_high << 12) + partial_prod_low;
            product_csa_carry <= 0; // No carry in first stage
            
            // Final product after carry propagation
            product <= product_csa_sum + product_csa_carry;
            
            // Normalization
            if (product[47]) begin
                z_mantissa <= product[47:24];
                z_exponent <= z_exponent + 1;
            end else begin
                z_mantissa <= product[46:23];
            end
            
            // Rounding bits
            guard_bit <= product[22];
            round_bit <= product[21];
            sticky <= |product[20:0];
        end else begin
            valid[2] <= 0;
        end
    end
    
    // Rounding logic
    assign rounded_mantissa = (guard_bit && (round_bit || sticky || z_mantissa[0])) ? 
                            (z_mantissa + 1) : z_mantissa;
    
    // Pipeline stage 4: Final result assembly
    always @(posedge clk) begin
        if (valid[2]) begin
            valid[3] <= 1;
            
            // Handle special cases
            case (special_case_type)
                2'b11: z <= 32'h7FC00000; // NaN
                2'b10: z <= {z_sign, 8'hFF, 23'b0}; // Infinity
                2'b01: z <= {z_sign, 31'b0}; // Zero
                default: begin // Normal case
                    if (z_exponent[8] || (z_exponent[7:0] == 8'hFF)) begin
                        z <= {z_sign, 8'hFF, 23'b0}; // Overflow
                    end else if (~|z_exponent[7:0]) begin
                        z <= {z_sign, 31'b0}; // Underflow
                    end else begin
                        z <= {z_sign, z_exponent[7:0], rounded_mantissa[22:0]};
                    end
                end
            endcase
        end else begin
            valid[3] <= 0;
        end
    end

endmodule