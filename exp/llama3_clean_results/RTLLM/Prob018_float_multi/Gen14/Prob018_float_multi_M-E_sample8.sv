module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [22:0] a_mantissa, b_mantissa;
reg [7:0]  a_exponent, b_exponent;
reg        a_sign, b_sign;
reg [49:0] product;
reg [23:0] rounded_mantissa;
reg [7:0]  final_exponent;
reg        final_sign;
reg [2:0]  state;

// Pipeline stage 1: Mantissa multiplication and preliminary exponent calculation
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
        product <= 0;
        state <= 0;
    end else if (state == 3'd0) begin
        // Input processing
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        state <= state + 1;
    end else if (state == 3'd1) begin
        // Mantissa multiplication
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        state <= state + 1;
    end else if (state == 3'd2) begin
        // Rounding, exponent adjustment, and sign determination
        // Integrated Rounding Unit (IRU)
        reg [1:0] rounding_mode;
        always @(*) begin
            case (a[1:0]) // Rounding mode selection
                2'b00: rounding_mode = 2'b00; // Round to nearest
                2'b01: rounding_mode = 2'b01; // Round towards plus infinity
                2'b10: rounding_mode = 2'b10; // Round towards minus infinity
                2'b11: rounding_mode = 2'b11; // Round towards zero
                default: rounding_mode = 2'b00;
            endcase
        end

        reg guard_bit, round_bit, sticky;
        always @(*) begin
            guard_bit <= product[24];
            round_bit <= product[25];
            sticky <= |product[26:0];
        end

        always @(*) begin
            case (rounding_mode)
                2'b00: begin // Round to nearest
                    if (guard_bit && (round_bit || sticky)) begin
                        rounded_mantissa <= product[47:25] + 1;
                    end else begin
                        rounded_mantissa <= product[47:25];
                    end
                end
                2'b01: begin // Round towards plus infinity
                    if (guard_bit || round_bit || sticky) begin
                        rounded_mantissa <= product[47:25] + 1;
                    end else begin
                        rounded_mantissa <= product[47:25];
                    end
                end
                2'b10: begin // Round towards minus infinity
                    rounded_mantissa <= product[47:25];
                end
                2'b11: begin // Round towards zero
                    rounded_mantissa <= product[47:25];
                end
            endcase
        end

        // Exponent Adjustment and Normalization Unit (EANU)
        always @(*) begin
            final_exponent <= a_exponent + b_exponent - 8'h7f;
            if (final_exponent > 8'hff) begin // Overflow
                final_exponent <= 8'hff;
            end else if (final_exponent < 8'h0) begin // Underflow
                final_exponent <= 8'h0;
            end
        end

        // Sign Bit Determination Unit (SBDU)
        always @(*) begin
            final_sign <= a_sign ^ b_sign;
        end

        z <= {final_sign, final_exponent, rounded_mantissa};
        state <= 0; // Back to IDLE
    end
end

endmodule