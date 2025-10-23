module float_multi(
    input clk, rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else if (counter == 3'b100) begin
        // No-op at the end of the operation sequence
    end else begin
        counter <= counter + 1'b1;
    end
end

// Input Processing
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Extract input components
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Special Cases Handling
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Identify NaN, infinity, or zero
        if ((a_exponent == 10'b1111111111) || (b_exponent == 10'b1111111111)) begin
            // Handle NaN and infinity cases
            if (a_exponent == 10'b1111111111 && b_exponent == 10'b1111111111) begin
                // Both are NaN or infinity
                if (a_exponent == 10'b1111111111 && a_mantissa != 0) begin
                    z <= {a_sign, a_exponent, a_mantissa};
                end else if (b_exponent == 10'b1111111111 && b_mantissa != 0) begin
                    z <= {b_sign, b_exponent, b_mantissa};
                end else if (a_exponent == 10'b1111111111 && a_mantissa == 0 && b_exponent == 10'b1111111111 && b_mantissa == 0) begin
                    z <= {1'b0, a_exponent, a_mantissa}; // Both are infinity, result is positive infinity
                end
            end else if (a_exponent == 10'b1111111111 && a_mantissa != 0) begin
                z <= {a_sign, a_exponent, a_mantissa};
            end else if (b_exponent == 10'b1111111111 && b_mantissa != 0) begin
                z <= {b_sign, b_exponent, b_mantissa};
            end else if (a_exponent == 10'b1111111111 && a_mantissa == 0) begin
                z <= {a_sign, a_exponent, a_mantissa}; // a is infinity
            end else if (b_exponent == 10'b1111111111 && b_mantissa == 0) begin
                z <= {b_sign, b_exponent, b_mantissa}; // b is infinity
            end
        end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
            // Handle zero cases
            if ((a_exponent == 0 && a_mantissa == 0) && (b_exponent == 0 && b_mantissa == 0)) begin
                z <= {1'b0, 10'b0000000000, 24'b0}; // Both are zero
            end else if (a_exponent == 0 && a_mantissa == 0) begin
                z <= {a_sign, a_exponent, a_mantissa}; // a is zero
            end else if (b_exponent == 0 && b_mantissa == 0) begin
                z <= {b_sign, b_exponent, b_mantissa}; // b is zero
            end
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize mantissas if necessary
        if (a_mantissa[23]) begin
            a_mantissa <= {a_mantissa[22:0], 1'b0};
            a_exponent <= a_exponent + 1'b1;
        end
        if (b_mantissa[23]) begin
            b_mantissa <= {b_mantissa[22:0], 1'b0};
            b_exponent <= b_exponent + 1'b1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Multiply mantissas and adjust signs and exponents
        product <= a_mantissa * b_mantissa;
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 10'b0111111111; // Subtract bias
        // Rounding and adjustment
        guard_bit <= product[1];
        round_bit <= product[0];
        sticky <= |product[49:2]; // OR of all bits below the guard bit
        if (guard_bit && (round_bit || sticky)) begin
            // Round up
            z_mantissa <= product[49:26] + 1'b1;
            if (z_mantissa[23]) begin
                z_mantissa <= {z_mantissa[22:0], 1'b0};
                z_exponent <= z_exponent + 1'b1;
            end
        end else begin
            z_mantissa <= product[49:26];
        end
        // Format the result
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule