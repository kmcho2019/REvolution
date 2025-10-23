module float_multi(
    input               clk,
    input               rst,
    input     [31:0]    a,
    input     [31:0]    b,
    output reg [31:0]   z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Reset logic
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000; // Reset counter
        z <= 32'b0; // Reset output
    end else begin
        case(counter)
            3'b000: begin // Initialization
                a_mantissa <= {a[22:0], 1'b1}; // Extract mantissa of a
                b_mantissa <= {b[22:0], 1'b1}; // Extract mantissa of b
                a_exponent <= a[30:23]; // Extract exponent of a
                b_exponent <= b[30:23]; // Extract exponent of b
                a_sign <= a[31]; // Extract sign bit of a
                b_sign <= b[31]; // Extract sign bit of b
                counter <= 3'b001; // Move to next state
            end
            3'b001: begin // Special cases handling
                if((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin // Check for NaN or infinity
                    if((a_exponent == 9'b111111111) && (a_mantissa != 0)) begin // NaN
                        z <= {1'b1, {8{1'b1}}, 23'b0}; // Output NaN
                    end else if((b_exponent == 9'b111111111) && (b_mantissa != 0)) begin // NaN
                        z <= {1'b1, {8{1'b1}}, 23'b0}; // Output NaN
                    end else if((a_exponent == 9'b111111111) && (a_mantissa == 0)) begin // Infinity
                        if(a_sign) begin
                            z <= {1'b1, {8{1'b1}}, 23'b0}; // Output negative infinity
                        end else begin
                            z <= {1'b0, {8{1'b1}}, 23'b0}; // Output positive infinity
                        end
                    end else if((b_exponent == 9'b111111111) && (b_mantissa == 0)) begin // Infinity
                        if(b_sign) begin
                            z <= {1'b1, {8{1'b1}}, 23'b0}; // Output negative infinity
                        end else begin
                            z <= {1'b0, {8{1'b1}}, 23'b0}; // Output positive infinity
                        end
                    end
                    counter <= 3'b100; // Move to final state
                end else begin
                    // Normalize mantissas if needed
                    if(a_mantissa[23] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 1;
                    end
                    if(b_mantissa[23] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= 3'b010; // Move to next state
                end
            end
            3'b010: begin // Multiplication
                product <= a_mantissa * b_mantissa; // Multiply mantissas
                z_exponent <= a_exponent + b_exponent + 1; // Calculate new exponent
                z_sign <= a_sign ^ b_sign; // Determine sign of result
                counter <= 3'b011; // Move to next state
            end
            3'b011: begin // Rounding and adjustment
                // Rounding logic (simplified for illustration purposes)
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= product[47:0] != 0;
                if((guard_bit && (round_bit || sticky))) begin
                    product[48:0] <= product[48:0] + 1; // Round up
                end
                z_mantissa <= product[47:24]; // Extract mantissa of result
                if(product[48]) begin
                    z_exponent <= z_exponent + 1; // Adjust exponent
                    z_mantissa <= z_mantissa >> 1; // Normalize mantissa
                end
                counter <= 3'b100; // Move to final state
            end
            3'b100: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa}; // Format result in IEEE 754
                counter <= 3'b000; // Reset counter
            end
            default: begin
                counter <= 3'b000; // Reset counter
            end
        endcase
    end
end

endmodule