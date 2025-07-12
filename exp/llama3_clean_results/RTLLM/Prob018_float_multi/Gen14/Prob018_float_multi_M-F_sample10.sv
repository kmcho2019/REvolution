module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State machine state
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [49:0] product; // Intermediate product of mantissas
reg [23:0] z_mantissa; // Mantissa of result
reg [7:0] z_exponent; // Exponent of result, adjusted for bias
reg z_sign; // Sign bit of result
reg guard_bit, round_bit, sticky; // Rounding control bits

// Combinational logic
assign product = {1'b1, a_mantissa} * {1'b1, b_mantissa};

// State machine
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
            3'b001: // Stage 2: Special case handling
                begin
                    if (a_exponent == 8'd255 || b_exponent == 8'd255) begin // NaN or infinity
                        if (a_exponent == 8'd255 && a_mantissa!= 0) begin // NaN
                            z <= 32'h7fc00000; // Result is NaN
                        end else if (b_exponent == 8'd255 && b_mantissa!= 0) begin // NaN
                            z <= 32'h7fc00000; // Result is NaN
                        end else if (a_exponent == 8'd255 && a_mantissa == 0) begin // Infinity
                            z <= (a_sign == 1)? 32'hff800000 : 32'h7f800000; // Result is infinity
                        end else if (b_exponent == 8'd255 && b_mantissa == 0) begin // Infinity
                            z <= (b_sign == 1)? 32'hff800000 : 32'h7f800000; // Result is infinity
                        end
                        state <= 3'b100; // Bypass further stages for special cases
                    end else if (a_exponent == 0 && a_mantissa == 0) begin // a is zero
                        z <= 32'b0; // Result is zero
                        state <= 3'b100; // Bypass further stages for zero
                    end else if (b_exponent == 0 && b_mantissa == 0) begin // b is zero
                        z <= 32'b0; // Result is zero
                        state <= 3'b100; // Bypass further stages for zero
                    end else begin
                        state <= 3'b010;
                    end
                end
            3'b010: // Stage 3: Mantissa multiplication and exponent calculation
                begin
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    if (z_exponent > 8'd254) begin
                        z_exponent <= 8'd255; // Overflow
                    end else if (z_exponent < 8'd1) begin
                        z_exponent <= 8'd1; // Underflow, denormalize
                    end
                    state <= 3'b011;
                end
            3'b011: // Stage 4: Rounding and normalization
                begin
                    // Rounding to nearest even (RNE)
                    guard_bit <= product[24];
                    round_bit <= product[25];
                    sticky <= |product[26:0];
                    if (round_bit && (guard_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1;
                    end else begin
                        z_mantissa <= product[49:26];
                    end
                    // Normalize result if necessary
                    if (z_mantissa[23]) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                    z_sign <= a_sign ^ b_sign;
                    state <= 3'b100;
                end
            3'b100: // Stage 5: Output generation
                begin
                    if (z_exponent == 8'd255) begin // Overflow or infinity
                        if (z_mantissa!= 0) begin // NaN
                            z <= 32'h7fc00000;
                        end else begin // Infinity
                            z <= (z_sign == 1)? 32'hff800000 : 32'h7f800000;
                        end
                    end else if (z_exponent == 0) begin // Underflow or zero
                        if (z_mantissa == 0) begin // Zero
                            z <= 32'b0;
                        end else begin // Denormalized
                            z <= {z_sign, 8'b0, z_mantissa};
                        end
                    end else begin // Normalized result
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                    state <= 3'b000; // Reset state machine
                end
            default: state <= 3'b000;
        endcase
    end
end

endmodule