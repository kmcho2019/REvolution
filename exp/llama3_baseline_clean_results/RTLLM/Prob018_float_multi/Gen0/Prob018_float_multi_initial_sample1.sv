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

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input Processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'b001: begin
                // Special Cases Handling
                if ((a_exponent == 8'b11111111) && (a_mantissa != 24'b0)) begin
                    // NaN
                    z <= 32'b1 << 31;
                end else if ((b_exponent == 8'b11111111) && (b_mantissa != 24'b0)) begin
                    // NaN
                    z <= 32'b1 << 31;
                end else if ((a_exponent == 8'b11111111) && (a_mantissa == 24'b0)) begin
                    // Infinity
                    if (b_exponent == 8'b11111111) begin
                        // Infinity * Infinity = Infinity
                        z <= {1'b0, 8'b11111111, 23'b0};
                    end else begin
                        // Infinity * Finite = Infinity
                        z <= {1'b0, 8'b11111111, 23'b0};
                    end
                end else if ((b_exponent == 8'b11111111) && (b_mantissa == 24'b0)) begin
                    // Finite * Infinity = Infinity
                    z <= {1'b0, 8'b11111111, 23'b0};
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Multiplication and Normalization
                product <= {a_mantissa, 26'b0} * {b_mantissa, 26'b0};
                z_mantissa <= product[49:26];
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                if (product[25]) begin
                    // Normalize
                    z_mantissa <= product[48:25];
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Rounding and Adjustment
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];
                if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
                    // Round up
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa == 24'b100000000000000000000000) begin
                        // Overflow
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= 24'b0;
                    end
                end
                counter <= counter + 1;
            end
            3'b100: begin
                // Output Generation
                if (z_exponent == 8'b00000000) begin
                    // Underflow
                    z <= {z_sign, 8'b0, z_mantissa};
                end else if (z_exponent == 8'b11111111) begin
                    // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
            default: begin
                counter <= counter + 1;
            end
        endcase
    end
end

endmodule