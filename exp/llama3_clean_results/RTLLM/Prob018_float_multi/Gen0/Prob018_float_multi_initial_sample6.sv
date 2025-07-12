module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;
    
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
            counter <= 0;
            z <= 0;
        end else begin
            // Input processing
            if (counter == 0) begin
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= counter + 1;
            end else if (counter == 1) begin
                // Special cases handling
                if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                    z <= 32'h7fc00000; // NaN
                end else if (a_exponent == 8'hff && a_mantissa == 0) begin
                    if (a_sign == b_sign) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else begin
                        z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                    end
                end else if (b_exponent == 8'hff && b_mantissa == 0) begin
                    if (a_sign == b_sign) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else begin
                        z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                    end
                end else begin
                    // Normalization
                    if (a_exponent == 0 && a_mantissa != 0) begin
                        a_exponent <= 1;
                        a_mantissa <= {1'b1, a_mantissa[22:1]};
                    end
                    if (b_exponent == 0 && b_mantissa != 0) begin
                        b_exponent <= 1;
                        b_mantissa <= {1'b1, b_mantissa[22:1]};
                    end
                    // Multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
            end else if (counter == 2) begin
                // Rounding and adjustment
                z_mantissa <= product[47:24];
                guard_bit <= product[23];
                round_bit <= product[22];
                sticky <= |product[21:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa == 24'h1000000) begin
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= 0;
                    end
                end
                // Output generation
                if (z_exponent > 255) begin
                    z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                end else if (z_exponent < 1) begin
                    z <= {1'b0, 8'h0, 23'd0}; // 0
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 0;
            end
        end
    end
endmodule