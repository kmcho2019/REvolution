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

// Always block for sequencing
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
    end else begin
        counter <= counter + 1;
    end
end

// Always block for input processing and special cases handling
always @ (posedge clk) begin
    if (counter == 3'd0) begin
        // Extract mantissas, exponents, and sign bits
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];

        // Check for special cases (NaN, infinity)
        if ((a_exponent == 8'd255 && a_mantissa != 23'd0) || (b_exponent == 8'd255 && b_mantissa != 23'd0)) begin
            // Handle NaN or infinity
            z_sign <= 1'b0; // Default sign for NaN or infinity
            z_exponent <= 8'd255;
            z_mantissa <= 23'd0;
        end
    end
end

// Always block for normalization and multiplication
always @ (posedge clk) begin
    if (counter == 3'd1) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
            b_exponent <= b_exponent - 1;
        end

        // Multiply mantissas and combine signs
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 127; // Subtract bias
    end
end

// Always block for rounding and adjustment
always @ (posedge clk) begin
    if (counter == 3'd2) begin
        // Round the result
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];

        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[47:24] + 1;
        end else begin
            z_mantissa <= product[47:24];
        end

        // Adjust the exponent
        if (z_mantissa[23] == 1'b1) begin
            z_mantissa <= z_mantissa >> 1;
            z_exponent <= z_exponent + 1;
        end
    end
end

// Always block for output generation
always @ (posedge clk) begin
    if (counter == 3'd3) begin
        // Format the output in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};

        // Handle overflow and underflow
        if (z_exponent > 8'd254) begin
            // Overflow
            z <= {z_sign, 8'd255, 23'd0};
        end else if (z_exponent < 8'd1) begin
            // Underflow
            z <= {z_sign, 8'd0, 23'd0};
        end

        // Reset the counter
        counter <= 3'd0;
    end
end

endmodule