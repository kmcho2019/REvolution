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
    end
    else begin
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
                if ((a_exponent == 8'hFF && a_mantissa != 0) || (b_exponent == 8'hFF && b_mantissa != 0)) begin
                    z <= 32'h7FC00000; // NaN
                end
                else if (a_exponent == 8'hFF || b_exponent == 8'hFF) begin
                    z <= (a_sign || b_sign) ? 32'hFFC00000 : 32'h7F800000; // infinity
                end
                counter <= counter + 1;
            end
            3'b001: begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'b010: begin
                // Multiply mantissas and combine signs
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'h7F;

                // Round the result
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    product[47:0] <= product[47:0] + 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Adjust the exponent and format the result
                if (product[49]) begin
                    product <= product >> 1;
                    z_exponent <= z_exponent + 1;
                end
                z_mantissa <= product[47:24];

                // Handle overflow and underflow
                if (z_exponent > 8'hFF) begin
                    z <= (z_sign) ? 32'hFFC00000 : 32'h7F800000; // infinity
                end
                else if (z_exponent < 1) begin
                    z <= (z_sign) ? 32'hBFC00000 : 32'h3F800000; // zero
                end
                else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule