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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin // Initialization and input processing
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                // Special cases handling
                if ((a_exponent == 9'hff && a_mantissa != 0) || (b_exponent == 9'hff && b_mantissa != 0)) begin
                    // NaN or infinity handling
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 9'hff;
                    z_mantissa <= 24'h0;
                end else if (a_exponent == 9'hff || b_exponent == 9'hff) begin
                    // Infinity handling
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 9'hff;
                    z_mantissa <= 24'h0;
                end else begin
                    counter <= counter + 1;
                end
            end
            1: begin // Multiplication and exponent calculation
                product <= (a_mantissa + 24'h100000) * (b_mantissa + 24'h100000);
                z_exponent <= a_exponent + b_exponent - 9'h7f;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            2: begin // Normalization and rounding
                z_mantissa <= product[48:25];
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];
                // Rounding
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                end
                // Overflow handling
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= counter + 1;
            end
            3: begin // Output formatting
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end
            default: counter <= 0;
        endcase
    end
end

endmodule