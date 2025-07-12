module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [9:0] z_exponent; // to hold exponent sum and adjustments
    reg [23:0] a_mantissa, b_mantissa;
    reg [49:0] product; // 24x24 = 48 bits product, use 50 for shifts and rounding
    reg [23:0] z_mantissa; 

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Special case flags
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Temporary signals
    reg product_msb;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            product <= 50'd0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            a_is_nan <= 1'b0;
            b_is_nan <= 1'b0;
            a_is_inf <= 1'b0;
            b_is_inf <= 1'b0;
            a_is_zero <= 1'b0;
            b_is_zero <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract fields from inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];

                    // Detect special cases for a
                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    a_is_inf <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                    a_is_zero <= (a[30:23] == 8) && (a[22:0] == 0) || (a[30:23] == 0) && (a[22:0] == 0);

                    // Detect special cases for b
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                    b_is_inf <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                    b_is_zero <= (b[30:23] == 8) && (b[22:0] == 0) || (b[30:23] == 0) && (b[22:0] == 0);

                    // Prepare mantissas: add implicit leading 1 for normalized numbers, else 0 for zeros/denormals
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Prepare sign of result
                    z_sign <= a[31] ^ b[31];

                    // Reset output to zero at start
                    z <= 32'd0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Special cases handling: NaN, Inf, zero
                    if (a_is_nan || b_is_nan) begin
                        // Output quiet NaN (sign=0, exponent=255, mantissa MSB=1)
                        z <= {1'b0,8'hFF,1'b1,22'd0};
                        counter <= 3'd0; // Done
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0,8'hFF,1'b1,22'd0};
                        counter <= 3'd0; // Done
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * finite => Inf
                        z <= {z_sign,8'hFF,23'd0};
                        counter <= 3'd0; // Done
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero * anything = zero
                        z <= {z_sign,31'd0};
                        counter <= 3'd0; // Done
                    end else begin
                        // Proceed with multiplication

                        // Compute exponent sum with bias adjustment
                        // Using 10 bits for exponent to cover possible overflow
                        z_exponent <= (a_exponent + b_exponent) - 8'd127;

                        // Multiply mantissas: 24 bits * 24 bits = 48 bits product
                        // Use 50 bits to simplify shift & rounding extraction
                        product <= a_mantissa * b_mantissa;

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Normalize product and prepare rounding bits

                    // If MSB of product (bit 47) is 1, shift right by 1 and increment exponent
                    if (product[47]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 10'd1;
                    end

                    // Mantissa bits: product[46:23], total 24 bits including implicit leading 1
                    z_mantissa <= product[46:23];

                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= |product[20:0];

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Round to nearest even

                    if (guard_bit && (round_bit | sticky_bit | z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1'b1;
                        // Check mantissa overflow after rounding
                        if (z_mantissa == 24'hFFFFFF) begin
                            // Overflow: shift mantissa right, increment exponent
                            z_mantissa <= z_mantissa >> 1;
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Handle overflow and underflow of exponent and assemble output

                    if (z_exponent >= 10'd255) begin
                        // Overflow => infinity
                        z <= {z_sign,8'hFF,23'd0};
                    end else if (z_exponent <= 0) begin
                        // Underflow => zero (flush to zero)
                        z <= {z_sign,31'd0};
                    end else begin
                        // Normal result: sign + exponent + mantissa (remove implicit leading 1)
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd0; // Done, restart
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule