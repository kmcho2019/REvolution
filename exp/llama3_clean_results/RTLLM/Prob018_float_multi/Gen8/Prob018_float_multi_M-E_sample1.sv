module float_multi_arch(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa;
    reg [8:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [49:0] product;
    reg [2:0] counter;
    reg guard_bit, round_bit, sticky;

    // LUT for rounding
    reg [1:0] round_mode;

    // Input Processing
    always @(posedge clk) begin
        if (rst) begin
            a_mantissa <= 0;
            a_exponent <= 0;
            a_sign <= 0;
            b_mantissa <= 0;
            b_exponent <= 0;
            b_sign <= 0;
        end else begin
            a_mantissa <= a[22:0];
            a_exponent <= a[30:23];
            a_sign <= a[31];
            b_mantissa <= b[22:0];
            b_exponent <= b[30:23];
            b_sign <= b[31];
        end
    end

    // Fixed-Point Multiplier with Overflow Handling
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
        end else begin
            // Normalize mantissas
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            // Simple overflow detection and saturation
            if (product[49]) begin
                product <= {1'b1, 23'd0, 25'd0}; // Saturate to maximum value
            end
        end
    end

    // Special Cases Handling
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else if ((a_exponent == 9'h1ff && a_mantissa!= 0) || (b_exponent == 9'h1ff && b_mantissa!= 0)) begin
            // NaN
            z <= 32'h7fc00000;
        end else if ((a_exponent == 9'h1ff && a_mantissa == 0) || (b_exponent == 9'h1ff && b_mantissa == 0)) begin
            // Infinity
            if (a_sign == b_sign) begin
                z <= {1'b1, 8'h7f, 23'd0}; // +Inf
            end else begin
                z <= {1'b0, 8'h7f, 23'd0}; // -Inf
            end
        end else begin
            // Normal cases
            if (counter == 0) begin
                // Start of operation
                counter <= counter + 1;
            end else if (counter == 1) begin
                // Rounding and exponent adjustment
                // Calculate guard, round, and sticky bits
                guard_bit <= product[24];
                round_bit <= product[25];
                sticky <= |product[26:0];

                // Determine rounding mode using LUT
                round_mode <= round_lut({guard_bit, round_bit, sticky});

                // Perform rounding
                if (round_mode == 2'b01) begin
                    // Round up
                    z[22:0] <= product[47:25] + 1;
                end else if (round_mode == 2'b10) begin
                    // Round down
                    z[22:0] <= product[47:25];
                end else if (round_mode == 2'b11) begin
                    // Round towards zero
                    z[22:0] <= product[47:25];
                end

                z[30:23] <= a_exponent + b_exponent - 9'h7f;
                z[31] <= a_sign ^ b_sign;
                counter <= counter + 1;
            end else begin
                // Reset counter
                counter <= 0;
            end
        end
    end

    // Round LUT
    function [1:0] round_lut(input [2:0] bits);
        case (bits)
            3'b000: round_lut = 2'b00; // Round towards zero
            3'b001: round_lut = 2'b01; // Round up
            3'b010: round_lut = 2'b10; // Round down
            3'b011: round_lut = 2'b11; // Round towards zero
            3'b100: round_lut = 2'b01; // Round up
            3'b101: round_lut = 2'b01; // Round up
            3'b110: round_lut = 2'b10; // Round down
            3'b111: round_lut = 2'b10; // Round down
        endcase
    endfunction
endmodule