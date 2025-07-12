module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [49:0] product; // Intermediate product of mantissas
reg [23:0] z_mantissa; // Mantissa of result
reg [7:0] z_exponent; // Exponent of result, adjusted for bias
reg z_sign; // Sign bit of result
reg guard_bit, round_bit, sticky; // Rounding control bits
reg [2:0] state; // State machine state

// Fixed-point multiplier
fixed_point_multiplier fp_multiplier(
    .a({1'b1, a_mantissa}),
    .b({1'b1, b_mantissa}),
    .product(product)
);

// Exponent calculation unit
exponent_calculator exp_calc(
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .z_exponent(z_exponent)
);

// Rounding and normalization unit
rounding_unit round_unit(
    .product(product),
    .guard_bit(guard_bit),
    .round_bit(round_bit),
    .sticky(sticky),
    .z_mantissa(z_mantissa)
);

// Control unit (FSM)
always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000;
        z_mantissa <= 0;
        z_exponent <= 0;
        z_sign <= 0;
    end else begin
        case (state)
            3'b000: // Stage 1: Input processing
                begin
                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    a_sign <= a[31];
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];
                    b_sign <= b[31];
                    state <= 3'b001;
                end
            3'b001: // Stage 2: Exponent calculation
                begin
                    exp_calc.calculate();
                    state <= 3'b010;
                end
            3'b010: // Stage 3: Mantissa multiplication
                begin
                    fp_multiplier.multiply();
                    state <= 3'b011;
                end
            3'b011: // Stage 4: Rounding and normalization
                begin
                    round_unit.round();
                    state <= 3'b100;
                end
            3'b100: // Stage 5: Output generation
                begin
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, z_exponent, z_mantissa};
                    state <= 3'b000; // Reset state machine
                end
            default: state <= 3'b000;
        endcase
    end
end

endmodule

module fixed_point_multiplier(
    input [24:0] a,
    input [24:0] b,
    output reg [49:0] product
);

// Fixed-point multiplication logic
always @(*) begin
    product = a * b;
end

endmodule

module exponent_calculator(
    input [8:0] a_exponent,
    input [8:0] b_exponent,
    output reg [7:0] z_exponent
);

// Exponent calculation logic
always @(*) begin
    z_exponent = a_exponent + b_exponent - 8'd127;
end

endmodule

module rounding_unit(
    input [49:0] product,
    output reg guard_bit,
    output reg round_bit,
    output reg sticky,
    output reg [23:0] z_mantissa
);

// Rounding logic
always @(*) begin
    guard_bit = product[24];
    round_bit = product[25];
    sticky = |product[26:0];
    if (round_bit && (guard_bit || sticky)) begin
        z_mantissa = product[49:26] + 1;
    end else begin
        z_mantissa = product[49:26];
    end
end

endmodule