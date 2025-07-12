module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    reg [2:0] counter;

    // Internal registers for inputs
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;

    // Intermediate signals
    reg [49:0] product;  // 24x24-bit multiplication result stored in 50 bits
    reg guard_bit, round_bit, sticky_bit;

    // Flags for special cases
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg special_case; // indicates if special case detected
    reg [31:0] special_result;

    localparam EXP_BIAS = 127;

    // Sequential logic: state machine and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear all internal registers
            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exp <= 0; b_exp <= 0; z_exp <= 0;
            a_mantissa <= 0; b_mantissa <= 0; z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            a_zero <= 0; b_zero <= 0; a_inf <= 0; b_inf <= 0; a_nan <= 0; b_nan <= 0;
            special_case <= 0;
            special_result <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

                    // Detect special cases for a
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    // Detect special cases for b
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissa with hidden bit for normalized numbers
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    special_case <= 0;
                    special_result <= 0;

                    // Check special cases to set output immediately if possible
                    // We'll defer final output assignment to the last cycle, but store special result here
                    if (a_nan || b_nan) begin
                        special_case <= 1;
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        special_case <= 1;
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN for inf * 0
                    end else if (a_inf || b_inf) begin
                        special_case <= 1;
                        special_result <= {(a_sign ^ b_sign), 8'hFF, 23'd0}; // Infinity
                    end else if (a_zero || b_zero) begin
                        special_case <= 1;
                        special_result <= {(a_sign ^ b_sign), 31'd0}; // Zero
                    end

                    counter <= 3'd1;
                end

                3'd1: begin
                    if (!special_case) begin
                        // Compute mantissa product (24 bits * 24 bits = 48 bits)
                        product <= a_mantissa * b_mantissa;
                        // Compute exponent sum with bias correction
                        // Exponent stored as 10 bits for overflow detection (+ some headroom)
                        z_exp <= a_exp + b_exp - EXP_BIAS;
                        // Calculate sign
                        z_sign <= a_sign ^ b_sign;
                    end
                    counter <= 3'd2;
                end

                3'd2: begin
                    if (!special_case) begin
                        // Normalize product:
                        // product is 48 bits. 
                        // If product[47] == 1, mantissa normalized already with leading 1.
                        // Else shift left 1, decrement exponent.

                        if (product[47]) begin
                            // No shift needed, mantissa top bit already 1
                            // z_exp already set, no change
                            // No action needed, but keep product as is
                        end else begin
                            // Shift left 1 and decrement exponent
                            product <= product << 1;
                            z_exp <= z_exp - 1;
                        end

                        // Extract mantissa bits (23 bits) from product[46:23]
                        z_mantissa <= product[46:23];

                        // Extract rounding bits from product
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                    counter <= 3'd3;
                end

                3'd3: begin
                    if (!special_case) begin
                        // Rounding: Round to nearest even
                        if (guard_bit && (round_bit | sticky_bit | z_mantissa[0])) begin
                            {z_mantissa, z_exp} <= {z_mantissa, z_exp} + 25'd1; // combined addition

                            // Check if mantissa overflowed after rounding (e.g., 24'hFFFFFF+1 = 24'h1000000)
                            if (z_mantissa == 24'hFFFFFF) begin
                                // Mantissa overflow: shift right and increment exponent
                                z_mantissa <= z_mantissa >> 1;
                                z_exp <= z_exp + 1;
                            end
                        end
                    end
                    counter <= 3'd4;
                end

                3'd4: begin
                    if (!special_case) begin
                        // Handle exponent overflow and underflow
                        if (z_exp >= 8'hFF) begin
                            // Overflow: set to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exp <= 0) begin
                            // Underflow: set to zero (no gradual underflow handling)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal number output
                            z <= {z_sign, z_exp[7:0], z_mantissa[22:0]};
                        end
                    end else begin
                        // Output special case result
                        z <= special_result;
                    end
                    counter <= 3'd0; // wrap around for next operation
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule