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
            0: begin // Initialization and Input Processing
                if (a[31] == 1'b1) a_sign <= 1'b1;
                else a_sign <= 1'b0;
                if (b[31] == 1'b1) b_sign <= 1'b1;
                else b_sign <= 1'b0;
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                counter <= counter + 1;
            end
            1: begin // Special Cases Handling
                if ((a_exponent == 9'hFF && a_mantissa!= 0) || (b_exponent == 9'hFF && b_mantissa!= 0)) begin
                    // NaN or infinity handling
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else if (a_exponent == 9'hFF || b_exponent == 9'hFF) begin
                    // Infinity handling
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // Normalization and Multiplication
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1;
                end
                // Multiply mantissas
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3: begin // Rounding and Adjustment
                // Round product
                guard_bit <= product[1];
                round_bit <= product[0];
                sticky <= product[49:2]!= 0;
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[48:25] + 1;
                end else begin
                    z_mantissa <= product[48:25];
                end
                // Adjust exponent
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            4: begin // Output Generation
                if (z_exponent > 9'h7F) begin
                    // Overflow
                    z_sign <= z_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 0;
                end else if (z_exponent < 9'h01) begin
                    // Underflow
                    z_sign <= z_sign;
                    z_exponent <= 0;
                    z_mantissa <= 0;
                end else begin
                    z_sign <= z_sign;
                    z_exponent <= z_exponent;
                    z_mantissa <= z_mantissa;
                end
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end
        endcase
    end
end

endmodule