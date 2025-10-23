module float_multi(
    input               clk,
    input               rst,
    input     [31:0]    a,
    input     [31:0]    b,
    output reg [31:0]   z
);

// FSM states
enum logic [2:0] {
    IDLE,
    EXTRACT,
    SPECIAL_CASES,
    NORMALIZE,
    MULTIPLY,
    ROUND,
    OUTPUT
} state, next_state;

// Mantissa and exponent registers
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;

// Sign bits
reg a_sign, b_sign, z_sign;

// Rounding control bits
reg guard_bit, round_bit, sticky;

// Operation flags
reg is_nan, is_inf;

// Dynamic rounding mode selector
reg [1:0] rounding_mode;

// Hardware accelerator signals
wire [49:0] product;
wire [8:0] new_exponent;

// Mantissa multiplier
mantissa_multiplier u_mult(
    .a(a_mantissa),
    .b(b_mantissa),
    .product(product)
);

// Exponent calculator
exponent_calculator u_exp(
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .new_exponent(new_exponent)
);

// Rounding unit
rounding_unit u_round(
    .product(product),
    .guard_bit(guard_bit),
    .round_bit(round_bit),
    .sticky(sticky),
    .rounding_mode(rounding_mode),
    .z_mantissa(z_mantissa)
);

always_comb begin
    case(state)
        IDLE: next_state = EXTRACT;
        EXTRACT: next_state = SPECIAL_CASES;
        SPECIAL_CASES: next_state = (is_nan || is_inf) ? OUTPUT : NORMALIZE;
        NORMALIZE: next_state = MULTIPLY;
        MULTIPLY: next_state = ROUND;
        ROUND: next_state = OUTPUT;
        OUTPUT: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= IDLE;
        z <= 32'b0;
    end else begin
        case(state)
            IDLE: begin
                // Reset signals
            end
            EXTRACT: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
            end
            SPECIAL_CASES: begin
                // Check for NaN and infinity
                is_nan <= (a_exponent == 9'b111111111 && a_mantissa != 0) || (b_exponent == 9'b111111111 && b_mantissa != 0);
                is_inf <= (a_exponent == 9'b111111111 && a_mantissa == 0) || (b_exponent == 9'b111111111 && b_mantissa == 0);
            end
            NORMALIZE: begin
                // Normalize mantissas if needed
                if(a_mantissa[23] == 0) begin
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1;
                end
                if(b_mantissa[23] == 0) begin
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1;
                end
            end
            MULTIPLY: begin
                // Multiply mantissas and calculate new exponent
                z_mantissa <= product[47:24];
                z_exponent <= new_exponent;
            end
            ROUND: begin
                // Round result
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= product[47:0] != 0;
                rounding_mode <= 2'b00; // Round to nearest
                z_mantissa <= u_round.z_mantissa;
            end
            OUTPUT: begin
                // Format result in IEEE 754
                z <= {z_sign, z_exponent, z_mantissa};
            end
            default: begin
                // Reset signals
            end
        endcase
        state <= next_state;
    end
end

endmodule

// Mantissa multiplier module
module mantissa_multiplier(
    input [23:0] a,
    input [23:0] b,
    output [49:0] product
);

assign product = a * b;

endmodule

// Exponent calculator module
module exponent_calculator(
    input [8:0] a_exponent,
    input [8:0] b_exponent,
    output [8:0] new_exponent
);

assign new_exponent = a_exponent + b_exponent + 1;

endmodule

// Rounding unit module
module rounding_unit(
    input [49:0] product,
    input guard_bit,
    input round_bit,
    input sticky,
    input [1:0] rounding_mode,
    output [23:0] z_mantissa
);

always_comb begin
    case(rounding_mode)
        2'b00: begin // Round to nearest
            if(guard_bit && (round_bit || sticky)) begin
                z_mantissa = product[47:24] + 1;
            end else begin
                z_mantissa = product[47:24];
            end
        end
        2'b01: begin // Round toward positive infinity
            z_mantissa = product[47:24] + 1;
        end
        2'b10: begin // Round toward negative infinity
            z_mantissa = product[47:24];
        end
        2'b11: begin // Round toward zero
            z_mantissa = product[47:24];
        end
        default: begin
            z_mantissa = 24'b0;
        end
    endcase
end

endmodule