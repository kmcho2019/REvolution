module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal registers and wires
reg [2:0] counter;

// Extracted fields
reg a_sign, b_sign, z_sign;
reg [9:0] a_exponent, b_exponent, z_exponent;  // 10 bits to handle exponent + intermediate calculations
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24-bit mantissa with implicit leading 1 for normal numbers

// Intermediate product of mantissas (24x24 = 48 bits) + 2 bits extra for shift = 50 bits
reg [49:0] product;

// Rounding bits
reg guard_bit, round_bit, sticky;

// Special flags for inputs
reg a_is_nan, a_is_inf, a_is_zero;
reg b_is_nan, b_is_inf, b_is_zero;

reg z_is_nan, z_is_inf, z_is_zero;

reg [31:0] a_reg, b_reg;

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'd0;
        z <= 32'd0;
        // Clear other regs
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        a_exponent <= 10'd0;
        b_exponent <= 10'd0;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        product <= 50'd0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
        z_sign <= 1'b0;
        z_exponent <= 10'd0;
        z_mantissa <= 24'd0;
        a_is_nan <= 1'b0;
        a_is_inf <= 1'b0;
        a_is_zero <= 1'b0;
        b_is_nan <= 1'b0;
        b_is_inf <= 1'b0;
        b_is_zero <= 1'b0;
        z_is_nan <= 1'b0;
        z_is_inf <= 1'b0;
        z_is_zero <= 1'b0;
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Load inputs and extract fields
                a_reg <= a;
                b_reg <= b;
                
                a_sign <= a[31];
                b_sign <= b[31];
                
                // Extract exponent and mantissa
                // Exponent stored with bias 127
                a_exponent <= {2'b00, a[30:23]}; // extend to 10 bits
                b_exponent <= {2'b00, b[30:23]};
                
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                
                // Detect special cases for a
                a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                a_is_inf <= (a[30:23] == 8'hFF) && (~(|a[22:0]));
                a_is_zero <= (a[30:23] == 8'd0) && (~(|a[22:0]));
                
                // Detect special cases for b
                b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                b_is_inf <= (b[30:23] == 8'hFF) && (~(|b[22:0]));
                b_is_zero <= (b[30:23] == 8'd0) && (~(|b[22:0]));
                
                counter <= counter + 3'd1;
            end
            3'd1: begin
                // Handle special cases output early, else multiply mantissas and add exponents
                
                // Determine output sign
                z_sign <= a_sign ^ b_sign;
                
                // Special case detection and handling precedence:
                // If any NaN input => NaN output
                // else if any zero and any inf => NaN output (invalid)
                // else if any inf => inf output
                // else if any zero => zero output
                // else normal multiply
                
                if (a_is_nan || b_is_nan) begin
                    z_is_nan <= 1'b1;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;
                    // NaN payload: just set quiet NaN with mantissa MSB=1
                    z_mantissa <= 24'h400000; // MSB of mantissa 1, rest 0
                    z_exponent <= 10'h1FF; // all ones exponent: 255 decimal extended to 10 bits, i.e., 0xFF = 255
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Invalid operation: inf * 0 = NaN
                    z_is_nan <= 1'b1;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;
                    z_mantissa <= 24'h400000;
                    z_exponent <= 10'h1FF;
                end else if (a_is_inf || b_is_inf) begin
                    // Result inf with sign
                    z_is_nan <= 1'b0;
                    z_is_inf <= 1'b1;
                    z_is_zero <= 1'b0;
                    z_mantissa <= 24'd0;
                    z_exponent <= 10'h1FF;
                end else if (a_is_zero || b_is_zero) begin
                    // Result zero
                    z_is_nan <= 1'b0;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b1;
                    z_mantissa <= 24'd0;
                    z_exponent <= 10'd0;
                end else begin
                    // Normal multiplication
                    z_is_nan <= 1'b0;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;
                    
                    // Multiply mantissas: 24 bits x 24 bits = 48 bits product
                    // Use 50 bits product to keep two extra bits for rounding shift
                    product <= a_mantissa * b_mantissa; // 48 bits valid (less bits zero padded)
                    
                    // Add exponents: subtract bias once (127)
                    // Each exponent is biased by 127
                    // Exponent sum = (a_exp - 127) + (b_exp -127) + 127 = a_exp + b_exp - 127
                    // Use extended 10 bits to avoid overflow
                    z_exponent <= a_exponent + b_exponent - 10'd127;
                end
                
                counter <= counter + 3'd1;
            end
            3'd2: begin
                // Normalize product, extract rounding bits and apply rounding
                
                if (z_is_nan) begin
                    // NaN output assembly
                    z <= {z_sign, 8'hFF, z_mantissa[22:0]};
                end else if (z_is_inf) begin
                    // Infinity output assembly
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (z_is_zero) begin
                    // Zero output assembly
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalize product
                    // product is 48 bits (max value ~ 2* (1.111... * 1.111...))
                    // product can be from 0x000000000000 to nearly 0xFFFFFFFE0000 (less than 2^48)
                    // The product is (a_mantissa * b_mantissa) with 24 bit numbers, leading 1 assumed
                    //
                    // We check bit 47 (MSB) to decide if product is normalized:
                    // If bit 47 is 1 => product >= 2 => shift right by 1 and increase exponent
                    // else no shift, exponent stays as is
                    
                    reg [49:0] norm_product;
                    reg [9:0] norm_exp;
                    reg [23:0] mantissa_rounded;
                    
                    // temp vars to extract rounding bits
                    reg g, r, s;
                    reg sticky_tmp;
                    
                    if (product[47]) begin
                        // MSB is 1: shift right 1
                        norm_product = product >> 1;
                        norm_exp = z_exponent + 10'd1;
                    end else begin
                        norm_product = product;
                        norm_exp = z_exponent;
                    end
                    
                    // Extract mantissa bits (23 bits)
                    // Mantissa in output is 23 bits, stored without leading 1.
                    // The leading 1 is implicit (normal number).
                    // We take bits [46:24] for mantissa (23 bits).
                    //
                    // Bits layout:
                    // norm_product[46:24] => mantissa bits (23 bits)
                    // norm_product[23] => guard bit (g)
                    // norm_product[22] => round bit (r)
                    // norm_product[21:0] => sticky bits (s)
                    
                    mantissa_rounded = norm_product[46:24];
                    g = norm_product[23];
                    r = norm_product[22];
                    sticky_tmp = |norm_product[21:0];
                    
                    // Sticky bit combines all bits below round bit
                    s = sticky_tmp ? 1'b1 : 1'b0;
                    
                    // Round to nearest even
                    // Round if (guard & (round | sticky | LSB))
                    // LSB is mantissa_rounded[0]
                    if (g && (r || s || mantissa_rounded[0])) begin
                        mantissa_rounded = mantissa_rounded + 1'b1;
                        // Handle mantissa overflow after rounding
                        if (mantissa_rounded == 24'h1000000) begin
                            // mantissa overflowed (24 bits), shift right and increment exponent
                            mantissa_rounded = 24'h800000; // 1 << 23
                            norm_exp = norm_exp + 10'd1;
                        end
                    end
                    
                    // Check exponent overflow/underflow
                    if (norm_exp >= 10'd255) begin
                        // Overflow => infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (norm_exp <= 10'd0) begin
                        // Underflow to zero (no gradual underflow handling)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number assemble
                        // Exponent in bits [30:23] with bias 127
                        // Mantissa bits [22:0]
                        z <= {z_sign, norm_exp[7:0], mantissa_rounded[22:0]};
                    end
                end
                
                counter <= 3'd0; // ready for next operation
            end
            default: begin
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule