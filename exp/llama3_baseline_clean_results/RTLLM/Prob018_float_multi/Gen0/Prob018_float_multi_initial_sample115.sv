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
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize counter and reset output
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end
    else begin
        case (counter)
            3'b000: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin
                // Special cases handling
                if ((a_exponent == 10'b11111111) && (b_exponent == 10'b11111111)) begin
                    // NaN
                    z <= 32'b7fc00000;
                    counter <= 3'b000;
                end
                else if ((a_exponent == 10'b11111111) && (b_exponent!= 10'b11111111)) begin
                    // Infinity
                    z <= 32'b7f800000;
                    counter <= 3'b000;
                end
                else if ((a_exponent!= 10'b11111111) && (b_exponent == 10'b11111111)) begin
                    // Infinity
                    z <= 32'b7f800000;
                    counter <= 3'b000;
                end
                else begin
                    // Normalization
                    if (a_exponent == 10'b0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= a_exponent + 1'b1;
                    end
                    if (b_exponent == 10'b0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= b_exponent + 1'b1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 10'b127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin
                // Rounding and adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1'b1;
                end
                else begin
                    z_mantissa <= product[47:24];
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // Output generation
                if (z_exponent == 10'b255) begin
                    // Overflow
                    z <= 32'b7f800000;
                end
                else if (z_exponent == 10'b0) begin
                    // Underflow
                    z <= 32'b00000000;
                end
                else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule