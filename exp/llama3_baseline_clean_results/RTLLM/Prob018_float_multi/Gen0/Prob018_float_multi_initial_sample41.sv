module float_multi(
    input           clk,
    input           rst,
    input   [31:0]  a,
    input   [31:0]  b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0]  a_exponent, b_exponent, z_exponent;
reg        a_sign, b_sign, z_sign;
reg [49:0] product;
reg        guard_bit, round_bit, sticky;

// Initialize signals and counters
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case(counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign     <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign     <= b[31];
                counter   <= counter + 1;
            end
            3'b001: begin // Special cases handling and normalization
                if((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // Handle NaN or infinity
                    z <= (a_exponent == 9'b11111111) ? a : b;
                end else if((a_exponent == 9'b0) || (b_exponent == 9'b0)) begin
                    // Normalize mantissas if necessary
                    if(a_exponent == 9'b0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                    end
                    if(b_exponent == 9'b0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                    end
                    counter <= counter + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin // Multiplication and exponent adjustment
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign     <= a_sign ^ b_sign;
                counter   <= counter + 1;
            end
            3'b011: begin // Rounding and adjustment
                // Implement rounding logic based on guard, round, and sticky bits
                // For simplicity, this example assumes rounding to nearest even
                if(product[0]) begin // Check least significant bit
                    // Round up if necessary
                    z_mantissa <= product[23:1] + 1;
                end else begin
                    z_mantissa <= product[23:1];
                end
                if(z_mantissa == 24'b1) begin // Check for overflow
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 24'b0;
                end
                counter <= counter + 1;
            end
            3'b100: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000; // Reset counter for next operation
            end
            default: begin
                counter <= 3'b000; // Reset counter on invalid state
            end
        endcase
    end
end

endmodule