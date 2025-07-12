module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent; // Adjusted to 9 bits for correct representation
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;
    reg [2:0] counter; // Cycle counter for operation sequencing

    // State Machine
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Combinational Logic
    assign a_mantissa = a[22:0];
    assign a_exponent = a[30:23];
    assign a_sign = a[31];
    assign b_mantissa = b[22:0];
    assign b_exponent = b[30:23];
    assign b_sign = b[31];

    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            case (counter)
                0: begin
                    // Special cases handling
                    if ((a_exponent == 9'h1ff && a_mantissa != 0) || (b_exponent == 9'h1ff && b_mantissa != 0)) begin
                        z <= 32'h7fc00000; // NaN
                    end else if (a_exponent == 9'h1ff && a_mantissa == 0) begin
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end else if (b_exponent == 9'h1ff && b_mantissa == 0) begin
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end
                end
                1: begin
                    // Multiplication and exponent adjustment
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent - 9'h7f; // Corrected for single precision
                    z_sign <= a_sign ^ b_sign;
                end
                2: begin
                    // Rounding and output generation
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

                    if (z_exponent > 9'hfe) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else if (z_exponent < 1) begin
                        z <= {1'b0, 8'h0, 23'd0}; // 0
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa}; // Corrected output formatting
                    end
                end
                default: begin
                    // Reset counter for next operation
                    counter <= 0;
                end
            endcase
        end
    end
endmodule