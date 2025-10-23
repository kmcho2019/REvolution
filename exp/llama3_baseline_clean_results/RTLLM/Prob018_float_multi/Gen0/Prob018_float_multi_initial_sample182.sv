module float_multi(clk, rst, a, b, z);

input clk;
input rst;
input [31:0] a;
input [31:0] b;
output reg [31:0] z;

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
    end
    else begin
        case (counter)
            3'b000: begin // Initialization and Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                if (a_exponent == 9'b11111111 || b_exponent == 9'b11111111) begin // Special Cases Handling
                    // Handle NaN and infinity
                    z_sign <= 1'b0; // Sign bit for result
                    z_exponent <= 9'b11111111; // Exponent for result
                    z_mantissa <= 23'b0; // Mantissa for result
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b001: begin // Normalization
                if (a_exponent != 9'b0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                end
                if (b_exponent != 9'b0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                end
                counter <= counter + 1'b1;
            end
            3'b010: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 9'b127;
                counter <= counter + 1'b1;
            end
            3'b011: begin // Rounding and Adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= product[47:0] != 0;
                if (guard_bit && (round_bit || sticky)) begin
                    product[48] <= 1'b1;
                end
                if (product[49]) begin
                    z_exponent <= z_exponent + 1'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b100: begin // Output Generation
                z_mantissa <= product[47:24];
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule