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

// Initialize the counter and extract input components
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        product <= 0;
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin // Initialize and extract input components
                a_mantissa <= {a[22:0], 1'b1}; // Assuming hidden bit is 1
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= {b[22:0], 1'b1}; // Assuming hidden bit is 1
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= 1;
            end
            1: begin // Handle special cases and normalize
                if ((a_exponent == 9'b11111111 && a_mantissa != 0) || (b_exponent == 9'b11111111 && b_mantissa != 0)) begin
                    z <= 32'b1; // NaN or infinity
                    counter <= 0;
                end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                    z <= 0; // Zero
                    counter <= 0;
                end else begin
                    if (a_exponent == 0) begin
                        a_exponent <= 1;
                        a_mantissa <= a_mantissa >> 1;
                    end
                    if (b_exponent == 0) begin
                        b_exponent <= 1;
                        b_mantissa <= b_mantissa >> 1;
                    end
                    counter <= 2;
                end
            end
            2: begin // Multiply and adjust exponent
                product <= {a_mantissa, 26'd0} * {b_mantissa, 26'd0};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3;
            end
            3: begin // Round and adjust exponent
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= |product[23:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 4;
            end
            4: begin // Generate output
                if (z_exponent > 255) begin
                    z <= {1'b1, 8'b11111111, 23'b0}; // Overflow
                end else if (z_exponent < 1) begin
                    z <= {z_sign, z_exponent + 127, z_mantissa[22:0]}; // Underflow
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa[22:0]};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule