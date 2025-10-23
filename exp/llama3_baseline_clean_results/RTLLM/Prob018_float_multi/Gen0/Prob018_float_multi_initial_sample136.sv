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

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end
    else begin
        case (counter)
            3'b000: begin
                // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'hFF && a_mantissa!= 24'b0) ||
                    (b_exponent == 8'hFF && b_mantissa!= 24'b0)) begin
                    z <= {a_sign || b_sign, 8'hFF, 23'b0}; // NaN or infinity result
                end
                else if ((a_exponent == 8'hFF && a_mantissa == 24'b0) ||
                         (b_exponent == 8'hFF && b_mantissa == 24'b0)) begin
                    z <= {a_sign || b_sign, 8'hFF, 23'b0}; // Infinity result
                end
                counter <= counter + 1;
            end
            3'b001: begin
                // Multiplication
                product <= (a_mantissa + 1) * (b_mantissa + 1);
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b010: begin
                // Rounding and Adjustment
                z_mantissa <= product[46:23];
                guard_bit <= product[22];
                round_bit <= product[21];
                sticky <= product[20] || product[19] || product[18] || product[17] ||
                          product[16] || product[15] || product[14] || product[13] ||
                          product[12] || product[11] || product[10] || product[9] ||
                          product[8] || product[7] || product[6] || product[5] ||
                          product[4] || product[3] || product[2] || product[1] || product[0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa == 24'b0) begin
                        z_exponent <= z_exponent + 1;
                    end
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Output Generation
                if (z_exponent > 255) begin
                    // Overflow
                    z <= {z_sign, 8'hFF, 23'b0};
                end
                else if (z_exponent < 1) begin
                    // Underflow
                    z <= {z_sign, 8'h0, 23'b0};
                end
                else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
            default: begin
                counter <= counter;
            end
        endcase
    end
end

endmodule