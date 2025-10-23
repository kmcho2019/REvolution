module float_multi (
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

// Synchronization and reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Extract sign, exponent, and mantissa from inputs
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= {1'b1, a[22:0]}; // implicit 1 in front of the mantissa

                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= {1'b1, b[22:0]}; // implicit 1 in front of the mantissa

                // Check for special cases (NaN and infinity)
                if (a_exponent == 9'b11111111 || b_exponent == 9'b11111111) begin
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'b11111111;
                    z_mantissa <= 24'b0;
                    counter <= 3'b111;
                end else begin
                    counter <= 3'b001;
                end
            end

            3'b001: begin
                // Normalize mantissas if necessary
                if (a_exponent != 9'b0) begin
                    // a is normalized
                end else begin
                    // a is denormalized
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent + 1'b1;
                end

                if (b_exponent != 9'b0) begin
                    // b is normalized
                end else begin
                    // b is denormalized
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent + 1'b1;
                end

                counter <= 3'b010;
            end

            3'b010: begin
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;

                // Calculate new exponent
                z_exponent <= a_exponent + b_exponent - 127;

                // Calculate sign of result
                z_sign <= a_sign ^ b_sign;

                counter <= 3'b011;
            end

            3'b011: begin
                // Round result
                guard_bit <= product[24];
                round_bit <= product[25];
                sticky <= |product[26:0];

                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1'b1;
                end else begin
                    z_mantissa <= product[49:26];
                end

                counter <= 3'b100;
            end

            3'b100: begin
                // Check for overflow and underflow
                if (z_exponent > 254) begin
                    z_exponent <= 9'b11111111;
                    z_mantissa <= 24'b0;
                end else if (z_exponent < -126) begin
                    z_exponent <= 1'b0;
                    z_mantissa <= 24'b0;
                end

                // Format result in IEEE 754 standard
                z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};

                counter <= 3'b111;
            end

            default: begin
                // idle state
            end
        endcase
    end
end

endmodule