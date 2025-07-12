module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // State machine to sequence the operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
        end else begin
            case (counter)
                3'b000: begin
                    // Extract mantissas, exponents, and sign bits
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Check for special cases (NaN, infinity)
                    if (a_exponent == 8'hff || b_exponent == 8'hff) begin
                        // Handle special cases
                        if (a_exponent == 8'hff && a_mantissa != 23'd0) begin
                            z <= 32'h7fc00000; // NaN
                        end else if (b_exponent == 8'hff && b_mantissa != 23'd0) begin
                            z <= 32'h7fc00000; // NaN
                        end else if (a_exponent == 8'hff) begin
                            z <= a; // Infinity
                        end else if (b_exponent == 8'hff) begin
                            z <= b; // Infinity
                        end
                        counter <= 3'b100;
                    end else begin
                        counter <= 3'b001;
                    end
                end
                3'b001: begin
                    // Normalize mantissas if necessary
                    if (a_mantissa[23] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 1;
                    end

                    counter <= 3'b010;
                end
                3'b010: begin
                    // Multiply mantissas and adjust exponents
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent + 1;

                    counter <= 3'b011;
                end
                3'b011: begin
                    // Round the result
                    guard_bit <= product[48];
                    round_bit <= product[47];
                    sticky <= |product[46:0];
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[47:25] + 1;
                    end else begin
                        z_mantissa <= product[47:25];
                    end

                    counter <= 3'b100;
                end
                3'b100: begin
                    // Format the output
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= z_exponent - 127;
                    if (z_exponent > 8'd127) begin
                        z <= {z_sign, 8'h7f, 23'd0}; // Overflow
                    end else if (z_exponent < 8'd-126) begin
                        z <= {z_sign, 8'h00, 23'd0}; // Underflow
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                end
            endcase
        end
    end

endmodule