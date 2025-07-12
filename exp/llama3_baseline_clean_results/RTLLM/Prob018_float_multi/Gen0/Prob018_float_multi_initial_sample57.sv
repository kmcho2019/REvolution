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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
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
                
                // Handle special cases (NaN, infinity)
                if ((a_exponent == 8'hff && a_mantissa!= 23'b0) || (b_exponent == 8'hff && b_mantissa!= 23'b0)) begin
                    // NaN or infinity case
                    z <= 32'h7fc00000; // NaN
                end else if (a_exponent == 8'hff || b_exponent == 8'hff) begin
                    // Infinity case
                    z <= 32'h7f800000; // Infinity
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b001: begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                    b_exponent <= b_exponent - 1;
                end
                
                counter <= counter + 1;
            end
            3'b010: begin
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;
                
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                
                counter <= counter + 1;
            end
            3'b011: begin
                // Round and adjust the result
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                    z_exponent <= z_exponent + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                
                counter <= counter + 1;
            end
            3'b100: begin
                // Format the result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};
                
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule