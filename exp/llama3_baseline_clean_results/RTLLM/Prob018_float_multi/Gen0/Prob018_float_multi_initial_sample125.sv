module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
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
        if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
            // Handle NaN or infinity
            if ((a_exponent == 9'b111111111) && (a_mantissa!= 23'b0)) begin
                z <= 32'b1; // NaN
            end else if ((b_exponent == 9'b111111111) && (b_mantissa!= 23'b0)) begin
                z <= 32'b1; // NaN
            end else if ((a_exponent == 9'b111111111) && (a_mantissa == 23'b0) && (b_exponent == 9'b111111111) && (b_mantissa == 23'b0)) begin
                z <= {1'b0, 8'b11111111, 23'b0}; // Infinity
            end
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'b011) begin
        if (a_mantissa[23] == 1'b0) begin
            // Normalize a
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1'b1;
        end
        if (b_mantissa[23] == 1'b0) begin
            // Normalize b
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1'b1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b100) begin
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent - 9'b01111011; // Bias
        z_sign <= a_sign ^ b_sign;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b101) begin
        guard_bit <= product[1];
        round_bit <= product[2];
        sticky <= (product[3:0]!= 4'b0);
        if ((guard_bit == 1'b1) && ((round_bit == 1'b1) || (sticky == 1'b1))) begin
            // Round up
            z_mantissa <= product[49:24] + 1'b1;
            z_exponent <= z_exponent + 1'b1;
        end else begin
            z_mantissa <= product[49:24];
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b110) begin
        if (z_exponent > 9'b11111111) begin
            // Overflow
            z <= {1'b0, 8'b11111111, 23'b0};
        end else if (z_exponent < 9'b1) begin
            // Underflow
            z <= {z_sign, z_exponent, z_mantissa};
        end else begin
            z <= {z_sign, z_exponent, z_mantissa};
        end
    end
end

endmodule