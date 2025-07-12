module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin // Input Processing
                a_mantissa <= {1'b1, a[22:0]}; // Implicit leading 1
                b_mantissa <= {1'b1, b[22:0]};
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'd1: begin // Special Cases Handling and Normalization
                if ((a_exponent == 8'd255 && a_mantissa != 24'd0) || (b_exponent == 8'd255 && b_mantissa != 24'd0)) begin // NaN or Infinity
                    z <= (a_exponent == 8'd255 ? a : b); // Propagate NaN or Infinity
                end else if (a_exponent == 8'd0 || b_exponent == 8'd0) begin // Denormal numbers
                    // Handle denormal numbers
                end else begin // Normal numbers, proceed with multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent - 127; // Adjusted exponent
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
            end
            3'd2: begin // Multiplication, Rounding, and Adjustment
                z_mantissa <= product[47:24]; // Extract 24 bits of the product
                guard_bit <= product[23];
                round_bit <= product[22];
                sticky <= |product[21:0];
                // Perform rounding (e.g., round to nearest even)
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa == 24'd0) begin // Overflow, adjust exponent
                        z_exponent <= z_exponent + 1;
                    end
                end
                counter <= counter + 1;
            end
            3'd3: begin // Output Generation
                if (z_exponent > 8'd254) begin // Overflow
                    z <= {z_sign, 8'd255, 23'd0};
                end else if (z_exponent < 8'd1) begin // Underflow
                    // Handle underflow, potentially producing a denormal number
                    if (z_exponent == 8'd0) begin
                        z <= {z_sign, 8'd0, z_mantissa[22:0]};
                    end else begin
                        z <= {z_sign, 8'd0, 23'd0};
                    end
                end else begin // Normal result
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                end
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule