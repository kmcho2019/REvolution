module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end
    else begin
        if (counter == 3'd0) begin
            // Input Processing
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];
            counter <= counter + 1;
        end
        else if (counter == 3'd1) begin
            // Special Cases Handling
            if ((a_exponent == 9'd255 && a_mantissa != 0) || (b_exponent == 9'd255 && b_mantissa != 0)) begin
                // NaN or Infinity
                z <= (a_exponent == 9'd255) ? a : b;
            end
            else if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
                // Infinity
                z_sign <= a_sign | b_sign;
                z_exponent <= 9'd255;
                z_mantissa <= 24'd0;
            end
            else begin
                // Normalization
                if (a_mantissa[23] == 0) begin
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 0) begin
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
        end
        else if (counter == 3'd2) begin
            // Multiplication
            product <= a_mantissa * b_mantissa;
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent + 1;
            counter <= counter + 1;
        end
        else if (counter == 3'd3) begin
            // Rounding and Adjustment
            guard_bit <= product[0];
            round_bit <= product[1];
            sticky <= |product[48:2];
            if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
                z_mantissa <= product[47:24] + 1;
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 24'd1;
                end
            end
            else begin
                z_mantissa <= product[47:24];
            end
            counter <= 0;
        end
    end
end

// Output Generation
always @(*) begin
    if (z_exponent > 9'd255) begin
        // Overflow
        z_sign <= z_sign;
        z_exponent <= 9'd255;
        z_mantissa <= 24'd0;
    end
    else if (z_exponent < 9'd1) begin
        // Underflow
        z_sign <= z_sign;
        z_exponent <= 9'd0;
        z_mantissa <= 24'd0;
    end
    else begin
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule