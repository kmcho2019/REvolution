module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end
    else begin
        case (counter)
            3'b000: begin // Input processing
                // Extract mantissa, exponent, and sign bit
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'hff && a_mantissa != 23'b0) || 
                    (b_exponent == 8'hff && b_mantissa != 23'b0)) begin
                    z <= 32'h7fc00000; // NaN
                end
                else if ((a_exponent == 8'hff && a_mantissa == 23'b0) || 
                         (b_exponent == 8'hff && b_mantissa == 23'b0)) begin
                    z <= 32'h7f800000; // Infinity
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b001: begin // Multiplication
                // Normalize mantissas if necessary
                if (a_exponent != 8'h0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                end
                if (b_exponent != 8'h0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                end

                // Multiply mantissas
                product <= a_mantissa * b_mantissa;

                // Adjust exponents
                z_exponent <= a_exponent + b_exponent - 8'h7f;

                // Combine signs
                z_sign <= a_sign ^ b_sign;

                counter <= counter + 1'b1;
            end
            3'b010: begin // Rounding and adjustment
                // Round product to 23 bits
                guard_bit <= product[22];
                round_bit <= product[21];
                sticky <= |product[20:0];

                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1'b1;
                end
                else begin
                    z_mantissa <= product[49:26];
                end

                // Adjust exponent if necessary
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1'b1;
                    z_mantissa <= z_mantissa >> 1;
                end

                counter <= counter + 1'b1;
            end
            3'b011: begin // Output generation
                // Format output in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa[22:0]};

                // Check for overflow and underflow
                if (z_exponent > 8'hff) begin
                    z <= 32'h7f800000; // Infinity
                end
                else if (z_exponent < 8'h1) begin
                    z <= 32'b0; // Underflow
                end

                counter <= 3'b000;
            end
        endcase
    end
end

endmodule