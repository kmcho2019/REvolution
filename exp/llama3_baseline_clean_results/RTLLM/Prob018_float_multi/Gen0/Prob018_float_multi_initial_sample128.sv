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
reg [8:0] a_exponent, b_exponent, z_exponent;
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
            3'b000: begin // Input processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling and normalization
                if ((a_exponent == 9'b11111111) && (a_mantissa!= 0)) begin
                    // a is NaN or infinity
                    z <= a;
                end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 0)) begin
                    // b is NaN or infinity
                    z <= b;
                end else if ((a_exponent == 0) && (a_mantissa == 0)) begin
                    // a is zero
                    z <= (a_sign == 1)? 32'b80000000 : 32'b00000000;
                end else if ((b_exponent == 0) && (b_mantissa == 0)) begin
                    // b is zero
                    z <= (b_sign == 1)? 32'b80000000 : 32'b00000000;
                end else begin
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]} << 1;
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]} << 1;
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                // Round to nearest even
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    product[49:25] <= product[49:25] + 1;
                end
                z_mantissa <= product[49:26];
                // Adjust exponent
                if (product[50]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                // Handle overflow and underflow
                if (z_exponent > 255) begin
                    z <= (z_sign == 1)? 32'bff800000 : 32'b7f800000;
                end else if (z_exponent < -126) begin
                    z <= (z_sign == 1)? 32'b80000000 : 32'b00000000;
                end else begin
                    z <= {z_sign, z_exponent[7:0] + 127, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule