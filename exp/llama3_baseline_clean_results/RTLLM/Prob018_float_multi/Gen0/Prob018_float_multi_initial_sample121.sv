module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter on reset
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
                counter <= 3'b001;
            end
            3'b001: begin
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 10'b11111111 && a_mantissa!= 0) || 
                    (b_exponent == 10'b11111111 && b_mantissa!= 0)) begin
                    // Handle NaN or infinity
                    z <= 32'b1; // Replace with actual NaN or infinity value
                    counter <= 3'b000;
                end else if ((a_exponent == 10'b11111111 && a_mantissa == 0) || 
                             (b_exponent == 10'b11111111 && b_mantissa == 0)) begin
                    // Handle infinity
                    z <= 32'b1; // Replace with actual infinity value
                    counter <= 3'b000;
                end else begin
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 10'b1;
                    end
                    if (b_mantissa[23] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 10'b1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Multiply mantissas and combine signs
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 10'b127;
                counter <= 3'b011;
            end
            3'b011: begin
                // Round and adjust the result
                z_mantissa <= product[49:26];
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= |product[23:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                end
                if (z_mantissa[23] == 1) begin
                    z_exponent <= z_exponent + 10'b1;
                    z_mantissa <= {1'b0, z_mantissa[22:0]};
                end
                counter <= 3'b100;
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