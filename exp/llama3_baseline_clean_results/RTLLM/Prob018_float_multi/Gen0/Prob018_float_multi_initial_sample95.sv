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

// Initialize the counter and other internal signals on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        z_mantissa <= 24'd0;
        a_exponent <= 9'd0;
        b_exponent <= 9'd0;
        z_exponent <= 9'd0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'd0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        // Handle state transitions and operations based on the current state (counter value)
        case (counter)
            3'b000: begin // State 0: Input processing
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= {1'b1, a[22:0]}; // Normalize the mantissa
                b_mantissa <= {1'b1, b[22:0]}; // Normalize the mantissa
                counter <= 3'b001;
            end
            3'b001: begin // State 1: Special cases handling and normalization
                // Check for NaN and infinity
                if ((a_exponent == 8'd255 && a_mantissa != 24'd0) || (b_exponent == 8'd255 && b_mantissa != 24'd0)) begin
                    // Handle NaN or infinity
                    z_exponent <= 8'd255;
                    if (a_mantissa != 24'd0 || b_mantissa != 24'd0) begin
                        z_mantissa <= 24'd0;
                    end else begin
                        z_mantissa <= a_mantissa + b_mantissa;
                    end
                    z_sign <= a_sign ^ b_sign;
                end else if (a_exponent == 8'd0 || b_exponent == 8'd0) begin
                    // Handle zero or denormalized numbers
                    z_exponent <= 8'd0;
                    z_mantissa <= a_mantissa * b_mantissa;
                    z_sign <= a_sign ^ b_sign;
                end else begin
                    // Proceed with multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent - 8'd127; // Adjust exponent
                    counter <= 3'b010;
                end
            end
            3'b010: begin // State 2: Multiplication, rounding, and adjustment
                // Perform rounding based on the product
                guard_bit <= product[47];
                round_bit <= product[46];
                sticky <= |product[45:0];
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    // Round down
                    z_mantissa <= product[46:23];
                end
                if (z_mantissa[23]) begin
                    // Carry in the exponent
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1;
                end
                counter <= 3'b011;
            end
            3'b011: begin // State 3: Output generation
                // Format the final result
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule