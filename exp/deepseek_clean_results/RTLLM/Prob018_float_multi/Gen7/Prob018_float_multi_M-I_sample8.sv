module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] partial_product, final_product;
    reg guard_bit, round_bit, sticky;
    reg special_case, is_nan, is_inf, is_zero;
    
    // Booth encoded multiplier signals
    reg [23:0] multiplicand;
    reg [11:0] booth_sel;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
            special_case <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 1: Input processing and special cases
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];
                    
                    // Extract exponents
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Extract mantissas (with implicit 1)
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Combined special case detection
                    is_nan <= (&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0]);
                    is_inf <= (&a[30:23] && ~|a[22:0]) || (&b[30:23] && ~|b[22:0]);
                    is_zero <= ~|a[30:0] || ~|b[30:0];
                    special_case <= is_nan || is_inf || is_zero;
                    
                    // Prepare for Booth multiplication
                    multiplicand <= a_mantissa;
                    booth_sel <= {b_mantissa, 1'b0};  // Append 0 for Booth encoding
                    
                    counter <= counter + 1;
                end
                
                1: begin  // Cycle 2: Booth multiplication (partial products)
                    partial_product <= 0;
                    for (i = 0; i < 12; i = i+1) begin
                        case (booth_sel[2*i+1:2*i])
                            2'b01: partial_product <= partial_product + (multiplicand << (2*i));
                            2'b10: partial_product <= partial_product - (multiplicand << (2*i));
                            default: ; // 00 or 11 - no operation
                        endcase
                    end
                    
                    // Add exponents and subtract bias (127)
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Final multiplication and normalization
                    final_product <= partial_product;
                    
                    if (special_case) begin
                        // Early output for special cases
                        if (is_nan) begin
                            z <= 32'h7FC00000;  // Canonical NaN
                        end else if (is_inf && is_zero) begin
                            z <= 32'h7FC00000;  // inf * 0 = NaN
                        end else if (is_inf) begin
                            z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                        end else begin  // is_zero
                            z <= {z_sign, 31'b0};  // +/- 0
                        end
                        counter <= 0;
                    end else begin
                        // Normalization
                        if (final_product[47]) begin  // Product >= 2
                            z_mantissa <= final_product[47:24];
                            z_exponent <= z_exponent + 1;
                        end else begin
                            z_mantissa <= final_product[46:23];
                        end
                        
                        // Extract rounding bits
                        guard_bit <= final_product[22];
                        round_bit <= final_product[21];
                        sticky <= |final_product[20:0];
                        
                        counter <= counter + 1;
                    end
                end
                
                3: begin  // Cycle 4: Rounding and final output
                    // Combined rounding logic
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin  // If mantissa overflows
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    // Handle overflow/underflow
                    if (&z_exponent || (z_exponent == 0)) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // +/- inf or 0
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule