module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents (including bias)
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Define the bias for single-precision floating-point numbers
localparam bias = 127;

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter
        z <= 32'd0; // Reset output
    end else begin
        case (counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0]; // Extract mantissa of a
                b_mantissa <= b[22:0]; // Extract mantissa of b
                a_exponent <= a[30:23] - bias; // Extract and bias exponent of a
                b_exponent <= b[30:23] - bias; // Extract and bias exponent of b
                a_sign <= a[31]; // Extract sign bit of a
                b_sign <= b[31]; // Extract sign bit of b
                if ((a_exponent == -127 && a_mantissa == 0) || (b_exponent == -127 && b_mantissa == 0)) begin
                    // Handle subnormal numbers
                    if (a_exponent == -127 && a_mantissa == 0)
                        z_mantissa <= {1'b1, b_mantissa};
                    else
                        z_mantissa <= {1'b1, a_mantissa};
                    z_exponent <= -126; // Minimum exponent for subnormal
                end else begin
                    z_mantissa <= {1'b1, a_mantissa}; // Normalize mantissa of a (assuming a is not subnormal)
                    z_exponent <= a_exponent; // Initialize exponent
                end
                counter <= counter + 1'b1;
            end
            3'b001: begin // Special cases handling and normalization
                if ((a_exponent == 128 && a_mantissa != 0) || (b_exponent == 128 && b_mantissa != 0)) begin
                    // Handle NaN
                    z <= 32'h7fc00000; // NaN representation
                    counter <= 3'b111; // Finish operation
                end else if ((a_exponent == 128 && a_mantissa == 0) || (b_exponent == 128 && b_mantissa == 0)) begin
                    // Handle infinity
                    if (a_exponent == 128 && a_mantissa == 0)
                        z_sign <= a_sign;
                    else
                        z_sign <= b_sign;
                    z <= {z_sign, 8'h7f, 23'h0}; // Infinity representation
                    counter <= 3'b111; // Finish operation
                end else if (z_exponent < -126) begin
                    // Underflow handling
                    z <= {z_sign, 8'h0, 23'h0}; // Zero representation
                    counter <= 3'b111; // Finish operation
                end else if (z_exponent > 127) begin
                    // Overflow handling
                    z <= {z_sign, 8'h7f, 23'h0}; // Infinity representation
                    counter <= 3'b111; // Finish operation
                end else begin
                    // Perform multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent + 1; // Adjust exponent
                    z_sign <= a_sign ^ b_sign; // Determine sign of result
                    counter <= counter + 1'b1;
                end
            end
            3'b010: begin // Rounding and adjustment
                // Normalize product
                if (product[49]) begin // Check for carry
                    z_mantissa <= product[48:25];
                    z_exponent <= z_exponent + 1'b1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                
                // Rounding
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1'b1;
                    if (z_mantissa == 24'd0) begin // Overflow
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= 1'b1;
                    end
                end
                
                counter <= counter + 1'b1;
            end
            3'b011: begin // Output generation
                // Pack result
                z <= {z_sign, z_exponent + bias, z_mantissa[22:0]};
                counter <= 3'b111; // Finish operation
            end
            default: begin
                // Operation finished, wait for reset
            end
        endcase
    end
end

endmodule