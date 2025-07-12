module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
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
    end else if (counter == 0) begin
        // Input Processing
        a_sign <= a[31];
        b_sign <= b[31];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_mantissa <= {1'b1, a[22:0]};
        b_mantissa <= {1'b1, b[22:0]};
        counter <= counter + 1;
    end else if (counter == 1) begin
        // Special Cases Handling
        if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
            // NaN or infinity
            z <= {a_sign || b_sign, 8'hff, 23'd0};
        end else if (a_exponent == 0 && a_mantissa == 0) begin
            // a is zero
            z <= {a_sign, 8'h0, 23'd0};
        end else if (b_exponent == 0 && b_mantissa == 0) begin
            // b is zero
            z <= {b_sign, 8'h0, 23'd0};
        end else begin
            // Multiplication
            product <= a_mantissa * b_mantissa;
            z_exponent <= a_exponent + b_exponent - 127;
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1;
        end
    end else if (counter == 2) begin
        // Rounding and Adjustment
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];
        if (guard_bit && (round_bit || sticky)) begin
            product[48:0] <= product[48:0] + 1;
        end
        z_mantissa <= product[48:25];
        if (product[49]) begin
            z_exponent <= z_exponent + 1;
        end
        counter <= counter + 1;
    end else if (counter == 3) begin
        // Output Generation
        if (z_exponent > 255) begin
            // Overflow
            z <= {z_sign, 8'hff, 23'd0};
        end else if (z_exponent < 1) begin
            // Underflow
            z <= {z_sign, 8'h0, 23'd0};
        end else begin
            z <= {z_sign, z_exponent, z_mantissa};
        end
        counter <= 0;
    end
end

endmodule