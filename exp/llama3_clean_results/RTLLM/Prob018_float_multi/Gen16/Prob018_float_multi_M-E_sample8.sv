module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Stage 1: Input Processing
reg [23:0] a_mantissa, b_mantissa;
reg [8:0] a_exponent, b_exponent;
reg a_sign, b_sign;

always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
    end
end

// Stage 2: Mantissa Multiplication
reg [49:0] product;
always @(posedge clk) begin
    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
end

// Stage 3: Exponent Calculation and Rounding
reg [8:0] z_exponent;
reg [23:0] z_mantissa;
reg z_sign;
reg guard_bit, round_bit, sticky;

always @(posedge clk) begin
    z_exponent <= a_exponent + b_exponent - 9'd127;
    if (z_exponent > 9'd254) begin
        z_exponent <= 9'd255; // Overflow
    end else if (z_exponent < 9'd1) begin
        z_exponent <= 9'd1; // Underflow, denormalize
    end
    z_mantissa <= product[49:26];
    z_sign <= a_sign ^ b_sign;
    guard_bit <= product[25];
    round_bit <= product[24];
    sticky <= |product[23:0];
    if (round_bit && (guard_bit || sticky)) begin
        z_mantissa <= z_mantissa + 1;
    end
end

// Stage 4: Output Generation
always @(posedge clk) begin
    if (z_exponent == 9'd255) begin // Overflow or infinity
        z <= (z_sign)? 32'hff800000 : 32'h7f800000;
    end else if (z_exponent == 0) begin // Underflow or zero
        if (z_mantissa == 0) begin // Zero
            z <= 32'b0;
        end else begin // Denormalized
            z <= {z_sign, 8'b0, z_mantissa};
        end
    end else begin // Normalized result
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
    end
end

endmodule