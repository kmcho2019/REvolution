module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    parameter IDLE     = 3'b001;
    parameter PROCESS  = 3'b010;
    parameter MULTIPLY = 3'b100;
    reg [2:0] state;

    // IEEE 754 constants
    parameter EXP_BIAS = 127;
    parameter EXP_MAX  = 255;
    parameter MANT_BITS = 23;

    // Input registers
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [23:0] a_mantissa, b_mantissa;

    // Pipeline signals
    wire [47:0] product = a_mantissa * b_mantissa;
    wire [9:0] exponent_sum = {2'b0, a_exponent} + {2'b0, b_exponent} - EXP_BIAS;
    wire result_sign = a_sign ^ b_sign;

    // Special case detection (combinational)
    wire a_is_zero = (a_reg[30:0] == 0);
    wire b_is_zero = (b_reg[30:0] == 0);
    wire a_is_inf = (a_exponent == EXP_MAX) && (a_reg[22:0] == 0);
    wire b_is_inf = (b_exponent == EXP_MAX) && (b_reg[22:0] == 0);
    wire a_is_nan = (a_exponent == EXP_MAX) && (a_reg[22:0] != 0);
    wire b_is_nan = (b_exponent == EXP_MAX) && (b_reg[22:0] != 0);
    wire a_is_denorm = (a_exponent == 0) && (a_reg[22:0] != 0);
    wire b_is_denorm = (b_exponent == 0) && (b_reg[22:0] != 0);

    // Result classification
    wire z_is_nan = a_is_nan | b_is_nan | (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero);
    wire z_is_inf = (a_is_inf | b_is_inf) & ~z_is_nan;
    wire z_is_zero = (a_is_zero | b_is_zero) & ~z_is_nan;

    // Normalization and rounding
    wire [47:0] product_norm = product[47] ? product : (product << 1);
    wire [9:0] z_exponent_tmp = product[47] ? (exponent_sum + 1) : exponent_sum;
    wire exponent_overflow = (z_exponent_tmp >= EXP_MAX);
    wire exponent_underflow = (z_exponent_tmp <= 0);

    // Rounding function
    function [23:0] round_mantissa;
        input [47:0] prod;
        reg guard, round, sticky;
        reg [23:0] mantissa;
        begin
            mantissa = prod[46:24];
            guard = prod[23];
            round = prod[22];
            sticky = |prod[21:0];

            // Round to nearest even
            if (guard && (round || sticky || mantissa[0])) begin
                round_mantissa = mantissa + 1;
                // Handle overflow by incrementing exponent
                if (&round_mantissa) begin
                    round_mantissa = {1'b1, {MANT_BITS{1'b0}};
                end
            end else begin
                round_mantissa = mantissa;
            end
        end
    endfunction

    wire [23:0] z_mantissa = round_mantissa(product_norm);
    wire [7:0] z_exponent = exponent_overflow ? EXP_MAX : 
                           (exponent_underflow ? 8'b0 : z_exponent_tmp[7:0]);

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    a_reg <= a;
                    b_reg <= b;
                    state <= PROCESS;
                end
                PROCESS: begin
                    a_sign <= a_reg[31];
                    b_sign <= b_reg[31];
                    a_exponent <= a_reg[30:23];
                    b_exponent <= b_reg[30:23];
                    // Handle denormals (implicit 0 instead of 1)
                    a_mantissa <= a_is_denorm ? {1'b0, a_reg[22:0]} : 
                                 {1'b1, a_reg[22:0]};
                    b_mantissa <= b_is_denorm ? {1'b0, b_reg[22:0]} : 
                                 {1'b1, b_reg[22:0]};
                    state <= MULTIPLY;
                end
                MULTIPLY: begin
                    // Output formation
                    if (z_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
                    end else if (z_is_inf) begin
                        z <= {result_sign, 8'hFF, 23'h0};
                    end else if (z_is_zero) begin
                        z <= {result_sign, 31'h0};
                    end else begin
                        z <= {result_sign, z_exponent, z_mantissa[22:0]};
                    end
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule