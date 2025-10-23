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

// Initial state
initial begin
    counter = 0;
    a_mantissa = 0;
    b_mantissa = 0;
    z_mantissa = 0;
    a_exponent = 0;
    b_exponent = 0;
    z_exponent = 0;
    a_sign = 0;
    b_sign = 0;
    z_sign = 0;
    product = 0;
    guard_bit = 0;
    round_bit = 0;
    sticky = 0;
end

// Main logic
always @(posedge clk) begin
    if (rst) begin
        // Reset the module
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            // Extract mantissas, exponents, and signs from inputs
            3'd0: begin
                a_mantissa <= {a[22:0], 1'b1}; // Implicit leading 1
                b_mantissa <= {b[22:0], 1'b1}; // Implicit leading 1
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            // Handle special cases (NaN, infinity)
            3'd1: begin
                if ((a_exponent == 8'd255 && a_mantissa != 0) || (b_exponent == 8'd255 && b_mantissa != 0)) begin
                    // NaN or infinity, set result accordingly
                    z <= {a_sign || b_sign, 8'd255, 23'd0};
                end else if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    // Infinity, set result accordingly
                    z <= {a_sign || b_sign, 8'd255, 23'd0};
                end else begin
                    counter <= counter + 1;
                end
            end
            // Normalize mantissas if necessary
            3'd2: begin
                if (a_mantissa[23] == 0) begin
                    // Normalize a_mantissa
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 0) begin
                    // Normalize b_mantissa
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            // Multiply mantissas and combine signs
            3'd3: begin
                product <= a_mantissa * b_mantissa;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            // Adjust exponent
            3'd4: begin
                z_exponent <= a_exponent + b_exponent - 127; // Adjust for bias
                counter <= counter + 1;
            end
            // Round result
            3'd5: begin
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[2:0];
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa <= product[49:26] + 1;
                end else begin
                    // Round down
                    z_mantissa <= product[49:26];
                end
                counter <= counter + 1;
            end
            // Format result
            3'd6: begin
                if (z_exponent > 8'd254) begin
                    // Overflow, set result to infinity
                    z <= {z_sign, 8'd255, 23'd0};
                end else if (z_exponent < 8'd1) begin
                    // Underflow, set result to zero
                    z <= {z_sign, 8'd0, 23'd0};
                end else begin
                    // Normal result
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                end
                counter <= 0; // Reset counter
            end
        endcase
    end
end

endmodule