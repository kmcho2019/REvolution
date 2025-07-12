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

// Special case constants
localparam INFINITY = 32'h7f800000;
localparam NAN = 32'h7fc00000;

always @ (posedge clk) begin
    if (rst) begin
        // Reset the counter and output
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                
                // Check for special cases
                if (a == INFINITY || b == INFINITY || (a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                    // Handle infinity and zero cases
                    if (a == INFINITY || b == INFINITY) begin
                        z <= INFINITY;
                    end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                        z <= 0;
                    end
                end else if (a == NAN || b == NAN) begin
                    // Handle NaN cases
                    z <= NAN;
                end
                
                counter <= counter + 1;
            end
            1: begin
                // Normalize mantissas if necessary
                if (a_mantissa[23]) begin
                    a_mantissa <= a_mantissa >> 1;
                    a_exponent <= a_exponent + 1;
                end
                if (b_mantissa[23]) begin
                    b_mantissa <= b_mantissa >> 1;
                    b_exponent <= b_exponent + 1;
                end
                
                counter <= counter + 1;
            end
            2: begin
                // Multiply mantissas and combine signs
                product <= (a_mantissa * b_mantissa);
                z_sign <= a_sign ^ b_sign;
                
                // Adjust exponents
                z_exponent <= a_exponent + b_exponent - 127;
                
                counter <= counter + 1;
            end
            3: begin
                // Round the result
                guard_bit <= product[0];
                round_bit <= product[1];
                sticky <= product[2] | product[3] | product[4] | product[5] | product[6] | product[7] | product[8] | product[9] | product[10] | product[11] | product[12] | product[13] | product[14] | product[15] | product[16] | product[17] | product[18] | product[19] | product[20] | product[21] | product[22] | product[23] | product[24] | product[25] | product[26] | product[27] | product[28] | product[29] | product[30] | product[31] | product[32] | product[33] | product[34] | product[35] | product[36] | product[37] | product[38] | product[39] | product[40] | product[41] | product[42] | product[43] | product[44] | product[45] | product[46] | product[47] | product[48];
                if (guard_bit && (round_bit || sticky)) begin
                    product <= product + 1;
                end
                
                counter <= counter + 1;
            end
            4: begin
                // Format the final result in IEEE 754 standard
                if (product[49]) begin
                    // Overflow
                    z_exponent <= 255;
                    z_mantissa <= 0;
                end else if (product[48:23] == 0) begin
                    // Underflow
                    z_exponent <= 0;
                    z_mantissa <= 0;
                end else begin
                    z_exponent <= z_exponent;
                    z_mantissa <= product[48:25];
                end
                
                // Combine sign, exponent, and mantissa to form the final result
                z <= {z_sign, z_exponent, z_mantissa};
                
                counter <= 0;
            end
        endcase
    end
end

endmodule