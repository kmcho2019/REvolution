module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;  // cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa;  // mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent;  // exponents of input and output numbers
reg a_sign, b_sign, z_sign;  // sign bits for inputs and output
reg [49:0] product;  // intermediate product of the mantissas
reg guard_bit, round_bit, sticky;  // rounding control bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;  // reset counter to zero
        z <= 32'b0;  // reset output
    end else begin
        case (counter)
            3'b000: begin
                // input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;  // combine signs
                counter <= 3'b001;
            end
            3'b001: begin
                // special case handling
                if ((a_exponent == 9'hff && a_mantissa != 23'b0) || (b_exponent == 9'hff && b_mantissa != 23'b0)) begin
                    // NaN or infinity
                    z <= 32'b1;  // default NaN
                end else if (a_exponent == 9'hff || b_exponent == 9'hff) begin
                    // infinity
                    z_exponent <= 9'hff;
                    z_mantissa <= 23'b0;
                    z_sign <= a_sign;
                    counter <= 3'b100;
                end else begin
                    // normalization
                    if (a_exponent == 9'h0) begin
                        a_mantissa <= {1'b1, a_mantissa};  // normalize a
                    end
                    if (b_exponent == 9'h0) begin
                        b_mantissa <= {1'b1, b_mantissa};  // normalize b
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // multiplication
                product <= {a_mantissa, 27'b0} * {b_mantissa, 27'b0};
                z_exponent <= a_exponent + b_exponent - 9'h7f;  // adjust exponent
                counter <= 3'b011;
            end
            3'b011: begin
                // rounding and adjustment
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= |product[23:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;  // round up
                end else begin
                    z_mantissa <= product[49:26];  // round down
                end
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;  // overflow
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;  // reset counter
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule