module float_multi(
    input         clk,
    input         rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing

// Extracted components of input and output floating-point numbers
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0]  a_exponent, b_exponent, z_exponent;
reg        a_sign, b_sign, z_sign;

// Intermediate product and rounding control bits
reg [49:0] product;
reg        guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin // Input processing
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign    <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign    <= b[31];
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'd255 && a_mantissa!= 0) || (b_exponent == 8'd255 && b_mantissa!= 0)) begin
                    z <= 32'd0; // NaN or infinity, result is NaN or infinity
                end else if ((a_exponent == 8'd255 && a_mantissa == 0) || (b_exponent == 8'd255 && b_mantissa == 0)) begin
                    z <= 32'd0; // Infinity, result is infinity
                end
                counter <= counter + 1;
            end
            3'd1: begin // Normalization and multiplication
                // Normalize mantissas if needed
                if (a_exponent!= 8'd0) begin
                    a_mantissa <= a_mantissa << (8 - a_exponent);
                end
                if (b_exponent!= 8'd0) begin
                    b_mantissa <= b_mantissa << (8 - b_exponent);
                end
                // Multiply mantissas
                product <= {1'd1, a_mantissa} * {1'd1, b_mantissa};
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'd127;
                counter <= counter + 1;
            end
            3'd2: begin // Rounding and adjustment
                // Round the result
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if ((guard_bit && (round_bit || sticky)) || round_bit) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                // Adjust exponent if necessary
                if (z_mantissa[23]) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3'd3: begin // Output generation
                // Format the final result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'd0;
            end
            default: begin
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule