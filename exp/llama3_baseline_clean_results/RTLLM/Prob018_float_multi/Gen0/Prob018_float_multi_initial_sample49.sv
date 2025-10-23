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

// FSM states
localparam [1:0] IDLE = 2'b00;
localparam [1:0] INPUT_PROCESSING = 2'b01;
localparam [1:0] MULTIPLICATION = 2'b10;
localparam [1:0] ROUNDING = 2'b11;

reg [1:0] state;

// Special cases
reg a_nan, b_nan, a_inf, b_inf;

// Normalize mantissa
function [23:0] normalize_mantissa;
input [23:0] mantissa;
input [8:0] exponent;
begin
    if (mantissa[23]) begin
        mantissa = mantissa << 1;
        exponent = exponent - 1;
    end
    else if (!mantissa[23]) begin
        while (!mantissa[23]) begin
            mantissa = mantissa >> 1;
            exponent = exponent + 1;
        end
    end
    normalize_mantissa = mantissa;
end
endfunction

always @(posedge clk) begin
    if (rst) begin
        // Reset
        counter <= 0;
        state <= IDLE;
        z <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                // Initialize
                counter <= 0;
                state <= INPUT_PROCESSING;
            end
            INPUT_PROCESSING: begin
                // Extract mantissas, exponents, and signs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special cases
                if (a_exponent == 9'b255 && a_mantissa != 0) a_nan <= 1;
                else if (a_exponent == 9'b255 && a_mantissa == 0) a_inf <= 1;
                if (b_exponent == 9'b255 && b_mantissa != 0) b_nan <= 1;
                else if (b_exponent == 9'b255 && b_mantissa == 0) b_inf <= 1;

                state <= MULTIPLICATION;
            end
            MULTIPLICATION: begin
                // Multiply mantissas
                product <= (a_mantissa + 1) * (b_mantissa + 1);

                // Calculate new exponent
                z_exponent <= a_exponent + b_exponent - 127;

                // Calculate new sign
                z_sign <= a_sign ^ b_sign;

                state <= ROUNDING;
            end
            ROUNDING: begin
                // Normalize product
                z_mantissa <= normalize_mantissa(product[48:25], z_exponent);

                // Round
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= product[22:0] != 0;
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa[23]) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                end

                // Handle overflow and underflow
                if (z_exponent > 9'b254) begin
                    z_exponent <= 9'b255;
                    z_mantissa <= 0;
                end
                else if (z_exponent < 1) begin
                    z_exponent <= 0;
                    z_mantissa <= z_mantissa >> (127 - z_exponent);
                end

                // Generate output
                z <= {z_sign, z_exponent, z_mantissa};

                state <= IDLE;
            end
        endcase
    end
end

endmodule