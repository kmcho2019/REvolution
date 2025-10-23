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
        counter <= 3'd0;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        a_exponent <= 9'd0;
        b_exponent <= 9'd0;
        z_exponent <= 9'd0;
        a_sign <= 1'd0;
        b_sign <= 1'd0;
        z_sign <= 1'd0;
        product <= 50'd0;
        guard_bit <= 1'd0;
        round_bit <= 1'd0;
        sticky <= 1'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Input processing
                a_mantissa <= {a[22:0], 23'd0} >> (23 - a[30:23] + 1'd1);
                b_mantissa <= {b[22:0], 23'd0} >> (23 - b[30:23] + 1'd1);
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'd1;
            end
            3'd1: begin
                // Special cases handling
                if ((a_exponent == 9'd255 && a_mantissa != 24'd0) || (b_exponent == 9'd255 && b_mantissa != 24'd0)) begin
                    // NaN or infinity
                    z <= 32'd0; // or specific value for NaN/infinity
                end else if ((a_exponent == 9'd0 && a_mantissa == 24'd0) || (b_exponent == 9'd0 && b_mantissa == 24'd0)) begin
                    // Zero
                    z <= 32'd0;
                end else begin
                    // Normalize
                    if (a_exponent == 9'd0) begin
                        a_mantissa <= a_mantissa << 1;
                        a_exponent <= a_exponent + 1'd1;
                    end
                    if (b_exponent == 9'd0) begin
                        b_mantissa <= b_mantissa << 1;
                        b_exponent <= b_exponent + 1'd1;
                    end
                    counter <= counter + 1'd1;
                end
            end
            3'd2: begin
                // Multiplication
                product <= (a_mantissa * b_mantissa);
                z_exponent <= a_exponent + b_exponent - 9'd127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1'd1;
            end
            3'd3: begin
                // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[2:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1'd1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                if (z_mantissa[23]) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'd1;
                end
                counter <= counter + 1'd1;
            end
            3'd4: begin
                // Output generation
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter <= 3'd0;
            end
            default: begin
                counter <= counter + 1'd1;
            end
        endcase
    end
end

endmodule