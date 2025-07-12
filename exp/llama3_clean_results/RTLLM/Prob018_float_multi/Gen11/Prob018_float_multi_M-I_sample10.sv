module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg [2:0] counter;
    reg guard_bit, round_bit, sticky;

    // Pipeline stages
    reg [22:0] pipe_a_mantissa, pipe_b_mantissa;
    reg [8:0] pipe_a_exponent, pipe_b_exponent;
    reg pipe_a_sign, pipe_b_sign;
    reg [49:0] pipe_product;
    reg [8:0] pipe_z_exponent;
    reg pipe_z_sign;

    always @(posedge clk) begin
        if (rst) begin
            // Reset logic
            a_mantissa <= 0;
            a_exponent <= 0;
            a_sign <= 0;
            b_mantissa <= 0;
            b_exponent <= 0;
            b_sign <= 0;
            counter <= 0;
            z <= 0;
        end else begin
            // Stage 1: Input processing and special cases handling
            if (counter == 0) begin
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];

                // Check for special cases (NaN, infinity)
                if ((a_exponent == 9'h1ff && a_mantissa!= 0) || (b_exponent == 9'h1ff && b_mantissa!= 0)) begin
                    // NaN
                    z <= 32'h7fc00000;
                end else if ((a_exponent == 9'h1ff && a_mantissa == 0) || (b_exponent == 9'h1ff && b_mantissa == 0)) begin
                    // Infinity
                    if (a_sign == b_sign) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else begin
                        z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                    end
                end else begin
                    counter <= counter + 1;
                end
            end

            // Stage 2: Multiplication and exponent adjustment
            else if (counter == 1) begin
                pipe_a_mantissa <= a_mantissa;
                pipe_b_mantissa <= b_mantissa;
                pipe_a_exponent <= a_exponent;
                pipe_b_exponent <= b_exponent;
                pipe_a_sign <= a_sign;
                pipe_b_sign <= b_sign;

                // Multiply mantissas and adjust exponents
                pipe_product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                pipe_z_exponent <= a_exponent + b_exponent - 9'h7f;
                pipe_z_sign <= a_sign ^ b_sign;

                counter <= counter + 1;
            end

            // Stage 3: Rounding and output formatting
            else if (counter == 2) begin
                // Calculate guard, round, and sticky bits
                guard_bit <= pipe_product[24];
                round_bit <= pipe_product[25];
                sticky <= |pipe_product[26:0];

                // Simplified rounding logic
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= pipe_product[47:25] + 1;
                end else begin
                    z_mantissa <= pipe_product[47:25];
                end

                z_exponent <= pipe_z_exponent;
                z_sign <= pipe_z_sign;

                // Format output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end
        end
    end
endmodule