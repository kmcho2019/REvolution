module float_multi(
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization and input processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        a_exponent <= 9'd0;
        b_exponent <= 9'd0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'd0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling and normalization
                if ((a_exponent == 9'd255 && a_mantissa != 24'd0) || (b_exponent == 9'd255 && b_mantissa != 24'd0)) begin
                    // NaN or infinity handling
                    if (a_exponent == 9'd255 && a_mantissa != 24'd0 && b_exponent == 9'd255 && b_mantissa != 24'd0) begin
                        // NaN * NaN = NaN
                        z <= 32'h7fc00000;
                    end else if (a_exponent == 9'd255 && a_mantissa != 24'd0) begin
                        // NaN * x = NaN
                        z <= a;
                    end else if (b_exponent == 9'd255 && b_mantissa != 24'd0) begin
                        // x * NaN = NaN
                        z <= b;
                    end else if (a_exponent == 9'd255) begin
                        // infinity * x = infinity
                        z <= {a_sign, 8'd255, 23'd0};
                    end else if (b_exponent == 9'd255) begin
                        // x * infinity = infinity
                        z <= {b_sign, 8'd255, 23'd0};
                    end
                end else begin
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent + 1;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[0];
                sticky <= |product[49:2];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                if (z_exponent > 9'd255) begin
                    // Overflow
                    z <= {z_sign, 8'd255, 23'd0};
                end else if (z_exponent < 1'd1) begin
                    // Underflow
                    z <= {z_sign, 8'd0, z_mantissa};
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule