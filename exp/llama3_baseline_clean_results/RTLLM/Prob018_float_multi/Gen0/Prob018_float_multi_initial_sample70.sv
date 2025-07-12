module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize all internal signals
initial begin
    counter = 3'b000;
    a_mantissa = 24'b0;
    b_mantissa = 24'b0;
    z_mantissa = 24'b0;
    a_exponent = 9'b0;
    b_exponent = 9'b0;
    z_exponent = 9'b0;
    a_sign = 1'b0;
    b_sign = 1'b0;
    z_sign = 1'b0;
    product = 50'b0;
    guard_bit = 1'b0;
    round_bit = 1'b0;
    sticky = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin // Reset to initial state
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 9'b0;
        b_exponent <= 9'b0;
        z_exponent <= 9'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin // State 0: Input extraction
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin // State 1: Special cases handling
                // Check for NaN and infinity
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Handle NaN or infinity
                    if ((a_exponent == 9'b111111111) && (a_mantissa != 24'b0)) begin
                        z <= 32'b1; // NaN result
                    end else if ((b_exponent == 9'b111111111) && (b_mantissa != 24'b0)) begin
                        z <= 32'b1; // NaN result
                    end else begin
                        // Handle infinity
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                    counter <= 3'b100; // Skip to output
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin // State 2: Normalization
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1'b1;
                end
                counter <= 3'b011;
            end
            3'b011: begin // State 3: Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b100;
            end
            3'b100: begin // State 4: Rounding and adjustment
                // Perform rounding
                guard_bit <= product[0];
                round_bit <= product[1];
                sticky <= |product[1:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:25] + 1'b1;
                end else begin
                    z_mantissa <= product[49:25];
                end
                // Adjust exponent
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'b1;
                end
                counter <= 3'b101;
            end
            3'b101: begin // State 5: Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000; // Reset counter
            end
            default: begin
                counter <= 3'b000; // Reset counter
            end
        endcase
    end
end

endmodule