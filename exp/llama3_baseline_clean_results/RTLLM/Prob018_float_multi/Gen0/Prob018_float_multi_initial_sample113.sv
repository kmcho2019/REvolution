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

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b001: begin
                // Special cases handling
                if ((a_exponent == 9'b11111111) && (a_mantissa!= 23'b0)) begin
                    // NaN
                    z <= 32'b1;
                end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 23'b0)) begin
                    // NaN
                    z <= 32'b1;
                end else if ((a_exponent == 9'b11111111) && (a_mantissa == 23'b0) && (b_exponent == 9'b11111111) && (b_mantissa == 23'b0)) begin
                    // Infinity
                    z <= 32'b1;
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Normalization
                if (a_mantissa[22] == 1'b0) begin
                    // Normalize a_mantissa
                    a_mantissa <= {1'b1, a_mantissa[21:0]};
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[22] == 1'b0) begin
                    // Normalize b_mantissa
                    b_mantissa <= {1'b1, b_mantissa[21:0]};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= counter + 1;
            end
            3'b100: begin
                // Rounding and adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= product[46:0]!= 50'b0;
                if ((guard_bit && (round_bit || sticky)) || (z_exponent == 255)) begin
                    // Overflow
                    z_exponent <= 255;
                    z_mantissa <= 23'b0;
                end else if (z_exponent == 0) begin
                    // Underflow
                    z_exponent <= 0;
                    z_mantissa <= product[49:26];
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= counter + 1;
            end
            3'b101: begin
                // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule