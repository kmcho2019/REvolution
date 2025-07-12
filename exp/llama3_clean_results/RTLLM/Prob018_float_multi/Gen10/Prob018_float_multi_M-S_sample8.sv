module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa;
    reg [8:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [49:0] product;
    reg [2:0] counter;
    reg guard_bit, round_bit, sticky;

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
            // Input processing stage
            if (counter == 0) begin
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= counter + 1;
            end

            // Special cases handling and multiplication stage
            else if (counter == 1) begin
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
                    // Normal cases
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z[30:23] <= a_exponent + b_exponent - 9'h7f;
                    z[31] <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
            end

            // Rounding and output formatting stage
            else if (counter == 2) begin
                // Calculate guard, round, and sticky bits
                guard_bit <= product[24];
                round_bit <= product[25];
                sticky <= |product[26:0];

                // Simplified rounding logic
                if (guard_bit || round_bit || sticky) begin
                    z[22:0] <= product[47:25] + 1;
                end else begin
                    z[22:0] <= product[47:25];
                end
                counter <= 0;
            end
        end
    end
endmodule