module float_multi(
    input           clk,
    input           rst,
    input   [31:0]  a,
    input   [31:0]  b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Extract mantissa, exponent, and sign from input floating-point numbers
always @(*) begin
    a_mantissa = a[22:0];
    b_mantissa = b[22:0];
    a_exponent = a[30:23];
    b_exponent = b[30:23];
    a_sign = a[31];
    b_sign = b[31];
end

// Handle special cases (NaN, infinity)
always @(*) begin
    if ((a_exponent == 9'b11111111) && (a_mantissa!= 0)) begin // a is NaN
        z = a;
    end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 0)) begin // b is NaN
        z = b;
    end else if ((a_exponent == 9'b11111111) && (a_mantissa == 0)) begin // a is infinity
        if (a_sign == b_sign) begin
            z = a; // result is infinity with same sign
        end else begin
            z = {1'b0, 8'b11111111, 23'b0}; // result is infinity with opposite sign
        end
    end else if ((b_exponent == 9'b11111111) && (b_mantissa == 0)) begin // b is infinity
        if (a_sign == b_sign) begin
            z = b; // result is infinity with same sign
        end else begin
            z = {1'b0, 8'b11111111, 23'b0}; // result is infinity with opposite sign
        end
    end
end

// Normalize mantissas if necessary
always @(*) begin
    if (a_exponent == 0) begin
        // a is subnormal
        a_mantissa = {1'b1, a_mantissa};
        a_exponent = 1;
    end
    if (b_exponent == 0) begin
        // b is subnormal
        b_mantissa = {1'b1, b_mantissa};
        b_exponent = 1;
    end
end

// Multiply mantissas and adjust exponent
always @(*) begin
    product = a_mantissa * b_mantissa;
    z_exponent = a_exponent + b_exponent - 127;
end

// Round result and adjust exponent
always @(*) begin
    guard_bit = product[1];
    round_bit = product[2];
    sticky = |product[2:0];
    if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
        // round up
        product = product + 1;
        if (product[48] == 1'b1) begin
            // overflow
            z_exponent = z_exponent + 1;
            product = product >> 1;
        end
    end
    z_mantissa = product[47:24];
end

// Format final result in IEEE 754 standard
always @(*) begin
    z_sign = a_sign ^ b_sign;
    if (z_exponent > 255) begin
        // overflow
        z = {z_sign, 8'b11111111, 23'b0};
    end else if (z_exponent < 1) begin
        // underflow
        z = {z_sign, 8'b0, z_mantissa};
    end else begin
        z = {z_sign, z_exponent, z_mantissa};
    end
end

// Operation sequencing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

endmodule