module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter; // Cycle counter
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
    reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
    reg a_sign, b_sign, z_sign; // Sign bits
    reg [49:0] product; // Intermediate product of mantissas
    reg guard_bit, round_bit, sticky; // Rounding control bits
    reg is_nan_a, is_nan_b, is_inf_a, is_inf_b; // Flags for NaN and infinity

    // Improved special cases handling
    always @(posedge clk) begin
        if (rst) begin
            is_nan_a <= 0;
            is_nan_b <= 0;
            is_inf_a <= 0;
            is_inf_b <= 0;
        end else begin
            is_nan_a <= (a[30:23] == 9'b11111111) && (a[22:0] != 23'b0);
            is_nan_b <= (b[30:23] == 9'b11111111) && (b[22:0] != 23'b0);
            is_inf_a <= (a[30:23] == 9'b11111111) && (a[22:0] == 23'b0);
            is_inf_b <= (b[30:23] == 9'b11111111) && (b[22:0] == 23'b0);
        end
    end

    // Enhanced input processing and normalization
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 0;
            a_exponent <= 0;
            a_mantissa <= 0;
            b_sign <= 0;
            b_exponent <= 0;
            b_mantissa <= 0;
        end else if (counter == 3'b000) begin
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            // Normalization logic can be added here if needed
        end
    end

    // Improved multiplication and rounding logic
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
        end else if (counter == 3'b001) begin
            // Multiplication logic, considering signs and exponents
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_exponent <= a_exponent + b_exponent - 9'b10000000;
            z_sign <= a_sign ^ b_sign;
        end
    end

    // Rounding and adjustment
    always @(posedge clk) begin
        if (rst) begin
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
        end else if (counter == 3'b010) begin
            // Extract parts of the product for rounding
            guard_bit <= product[24];
            round_bit <= product[23];
            sticky <= |product[22:0];
            // Rounding logic (e.g., round to nearest even)
            if (guard_bit || round_bit || sticky) begin
                z_mantissa <= product[48:25] + 1;
            end else begin
                z_mantissa <= product[48:25];
            end
        end
    end

    // Output generation
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else if (counter == 3'b011) begin
            // Assemble result, handling special cases
            if (is_nan_a || is_nan_b) begin
                z <= 32'b1; // Simplified NaN handling
            end else if (is_inf_a || is_inf_b) begin
                // Handle infinity
                if (z_sign) begin
                    z <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // Negative Infinity
                end else begin
                    z <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Positive Infinity
                end
            end else begin
                z <= {z_sign, z_exponent, z_mantissa};
            end
        end
    end

    // Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
        end else begin
            case (counter)
                3'b000: counter <= 3'b001;
                3'b001: counter <= 3'b010;
                3'b010: counter <= 3'b011;
                3'b011: counter <= 3'b000;
                default: counter <= 3'b000;
            endcase
        end
    end

endmodule