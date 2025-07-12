module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// State machine to control the operation sequence
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 9'b11111111 && a_mantissa!= 0) || (b_exponent == 9'b11111111 && b_mantissa!= 0)) begin
                    // NaN or infinity handling
                    z <= (a_exponent == 9'b11111111)? a : b;
                    counter <= 3'b100;
                end else if (a_exponent == 0 || b_exponent == 0) begin
                    // Zero or subnormal handling
                    if (a_exponent == 0 && b_exponent == 0) begin
                        z_exponent <= 0;
                        z_mantissa <= a_mantissa * b_mantissa;
                        z_sign <= a_sign ^ b_sign;
                        counter <= 3'b010;
                    end else begin
                        // Only one is zero or subnormal
                        z_exponent <= (a_exponent == 0)? b_exponent : a_exponent;
                        z_mantissa <= (a_exponent == 0)? a_mantissa * b_mantissa : b_mantissa * a_mantissa;
                        z_sign <= (a_exponent == 0)? a_sign ^ b_sign : b_sign ^ a_sign;
                        counter <= 3'b010;
                    end
                end else begin
                    counter <= 3'b001;
                end
            end
            3'b010: begin // Multiplication and normalization
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                // Determine rounding bits
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                    if (z_mantissa[23]) begin
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= 1;
                    end
                end else begin
                    z_mantissa <= product[49:26];
                end
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                // Finalize output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule