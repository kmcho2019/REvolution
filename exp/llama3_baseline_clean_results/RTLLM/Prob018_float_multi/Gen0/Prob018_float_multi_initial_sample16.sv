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

// Initialize counter
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

// Input processing
always @(posedge clk) begin
    if (counter == 3'b001) begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end
end

// Special cases handling
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Check for NaN or infinity
        if ((a_exponent == 9'hFF && a_mantissa!= 24'd0) || (b_exponent == 9'hFF && b_mantissa!= 24'd0)) begin
            z <= 32'h7FC00000; // Result is NaN
        end else if (a_exponent == 9'hFF || b_exponent == 9'hFF) begin
            z <= 32'h7F800000; // Result is infinity
        end
    end
end

// Normalization and multiplication
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1;
        end

        // Multiply mantissas and combine signs
        product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
        z_sign <= a_sign ^ b_sign;

        // Adjust exponent
        z_exponent <= a_exponent + b_exponent - 127;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Round the result
        guard_bit <= product[1];
        round_bit <= product[2];
        sticky <= |product[49:3];

        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[49:26] + 1;
        end else begin
            z_mantissa <= product[49:26];
        end

        // Adjust exponent if needed
        if (z_mantissa[23] == 1'b1) begin
            z_mantissa <= {1'b0, z_mantissa[22:0]};
            z_exponent <= z_exponent + 1;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Format the result in IEEE 754 standard
        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};

        // Check for overflow or underflow
        if (z_exponent == 9'hFF) begin
            z <= 32'h7F800000; // Overflow, result is infinity
        end else if (z_exponent == 9'h00) begin
            z <= 32'h00000000; // Underflow, result is zero
        end
    end
end

endmodule