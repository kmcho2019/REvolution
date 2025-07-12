module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the counter and signals
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'hff && a_mantissa!= 0) || (b_exponent == 8'hff && b_mantissa!= 0)) begin
                    // Handle NaN or infinity
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 8'hff;
                    z_mantissa <= 0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else if (a_exponent == 8'hff || b_exponent == 8'hff) begin
                    // Handle infinity
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 8'hff;
                    z_mantissa <= 0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else begin
                    // Proceed with multiplication
                    counter <= counter + 1;
                end
            end
            1: begin
                // Normalize mantissas if necessary
                if (a_exponent!= 0) begin
                    a_mantissa <= a_mantissa << (8 - a_exponent);
                end
                if (b_exponent!= 0) begin
                    b_mantissa <= b_mantissa << (8 - b_exponent);
                end
                
                // Perform multiplication
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                
                counter <= counter + 1;
            end
            2: begin
                // Round the result and adjust exponent
                {guard_bit, round_bit, sticky} <= product[49:47];
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                
                // Handle overflow and underflow
                if (z_exponent > 8'h7f) begin
                    z_exponent <= 8'h7f;
                    z_mantissa <= 0;
                end else if (z_exponent < 8'h01) begin
                    z_exponent <= 8'h01;
                    z_mantissa <= 0;
                end
                
                // Format the result
                z <= {z_sign, z_exponent, z_mantissa};
                
                counter <= 0;
            end
        endcase
    end
end

endmodule