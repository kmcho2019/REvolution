module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Direct assignments using combinational logic
assign a_sign = a[31]; // Extract sign bit of a
assign a_exponent = a[30:23]; // Extract exponent of a
assign a_mantissa = a[22:0]; // Extract mantissa of a
assign b_sign = b[31]; // Extract sign bit of b
assign b_exponent = b[30:23]; // Extract exponent of b
assign b_mantissa = b[22:0]; // Extract mantissa of b

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter
        z <= 32'b0; // Reset output
    end
end

// State machine logic
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Special Cases Handling
        if ((a_exponent == 9'b11111111) && (a_mantissa != 23'b0)) begin
            // NaN
            z <= 32'b11111111_10000000_00000000_00000000_00000000_00000000_00000000_0000;
        end else if ((b_exponent == 9'b11111111) && (b_mantissa != 23'b0)) begin
            // NaN
            z <= 32'b11111111_10000000_00000000_00000000_00000000_00000000_00000000_0000;
        end else if ((a_exponent == 9'b11111111) && (a_mantissa == 23'b0)) begin
            // Infinity
            if (a_sign) begin
                // Negative Infinity
                z <= 32'b10000000_10000000_00000000_00000000_00000000_00000000_00000000_0000;
            end else begin
                // Positive Infinity
                z <= 32'b00000000_10000000_00000000_00000000_00000000_00000000_00000000_0000;
            end
        end else if ((b_exponent == 9'b11111111) && (b_mantissa == 23'b0)) begin
            // Infinity
            if (b_sign) begin
                // Negative Infinity
                z <= 32'b10000000_10000000_00000000_00000000_00000000_00000000_00000000_0000;
            end else begin
                // Positive Infinity
                z <= 32'b00000000_10000000_00000000_00000000_00000000_00000000_00000000_0000;
            end
        end else begin
            z_sign <= a_sign ^ b_sign; // Determine sign of result
            z_exponent <= a_exponent + b_exponent - 9'b10000000; // Calculate new exponent
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa}; // Multiply mantissas
            counter <= counter + 1;
        end
    end else if (counter == 3'b001) begin
        // Rounding and Adjustment
        guard_bit <= product[24];
        round_bit <= product[23];
        sticky <= |product[22:0]; // Correct sticky bit calculation
        
        if (guard_bit || round_bit || sticky) begin
            // Rounding (compliant with IEEE 754)
            z_mantissa <= product[48:25] + 1;
        end else begin
            z_mantissa <= product[48:25];
        end
        
        // Handling overflow and underflow
        if (z_exponent > 9'b11111110) begin
            // Overflow
            z_exponent <= 9'b11111111;
            z_mantissa <= 23'b0;
            z_sign <= z_sign; // Preserve sign
        end else if (z_exponent < 9'b1) begin
            // Underflow
            z_exponent <= 9'b0;
            z_mantissa <= 23'b0;
            z_sign <= z_sign; // Preserve sign
        end
        
        counter <= counter + 1;
    end else if (counter == 3'b010) begin
        // Output Generation
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 3'b000; // Reset counter
    end
end

endmodule