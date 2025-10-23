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
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Extraction of mantissas, exponents, and sign bits
assign a_mantissa = a[22:0];
assign b_mantissa = b[22:0];
assign a_exponent = a[30:23];
assign b_exponent = b[30:23];
assign a_sign = a[31];
assign b_sign = b[31];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Input processing and special cases handling
                // Check for NaN or infinity
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Handle NaN or infinity
                    if ((a_exponent == 9'b111111111) && (b_exponent == 9'b111111111)) begin
                        z <= 32'b7fc00000; // NaN
                    end else if (a_exponent == 9'b111111111) begin
                        z <= a;
                    end else begin
                        z <= b;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b001: begin // Normalization
                // Normalize mantissas if necessary
                // Since Verilog doesn't support floating-point arithmetic directly,
                // we will simulate this step by assuming the mantissas are normalized.
                counter <= counter + 1'b1;
            end
            3'b010: begin // Multiplication
                // Multiply mantissas and combine signs
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 9'b011111111; // Subtract bias
                counter <= counter + 1'b1;
            end
            3'b011: begin // Rounding and adjustment
                // Round the product
                guard_bit <= product[0];
                round_bit <= product[1];
                sticky <= |product[49:2];
                if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
                    z_mantissa <= product[49:26] + 1'b1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                // Adjust exponent if necessary
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1'b1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= counter + 1'b1;
            end
            3'b100: begin // Output generation
                // Assemble the result
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule