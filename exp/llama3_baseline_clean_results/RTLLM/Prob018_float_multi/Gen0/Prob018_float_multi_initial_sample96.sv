module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0]  a_exponent, b_exponent, z_exponent;
reg         a_sign, b_sign, z_sign;
reg [49:0] product;
reg         guard_bit, round_bit, sticky;

// FSM states
enum logic [1:0] {
    IDLE,
    INPUT_PROCESSING,
    MULTIPLICATION,
    OUTPUT_GENERATION
} state, next_state;

always_ff @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (a!= 0 && b!= 0) begin
                    state <= INPUT_PROCESSING;
                end
            end
            INPUT_PROCESSING: begin
                counter <= counter + 1;
                if (counter == 1) begin
                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    a_sign <= a[31];
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];
                    b_sign <= b[31];
                    state <= MULTIPLICATION;
                end
            end
            MULTIPLICATION: begin
                counter <= counter + 1;
                if (counter == 2) begin
                    // Check for special cases (NaN, infinity)
                    if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
                        z_exponent <= 9'd255;
                        if (a_exponent == 9'd255 && b_exponent == 9'd255) begin
                            z_mantissa <= 23'd0;
                            z_sign <= a_sign ^ b_sign;
                        end else if (a_exponent == 9'd255) begin
                            z_mantissa <= a_mantissa;
                            z_sign <= a_sign;
                        end else begin
                            z_mantissa <= b_mantissa;
                            z_sign <= b_sign;
                        end
                        state <= OUTPUT_GENERATION;
                    end else begin
                        // Normalize mantissas
                        if (a_exponent!= 0) begin
                            a_mantissa <= {1'b1, a_mantissa};
                        end
                        if (b_exponent!= 0) begin
                            b_mantissa <= {1'b1, b_mantissa};
                        end
                        // Multiply mantissas
                        product <= a_mantissa * b_mantissa;
                        // Adjust exponents
                        z_exponent <= a_exponent + b_exponent - 9'd127;
                        // Determine sign
                        z_sign <= a_sign ^ b_sign;
                        state <= OUTPUT_GENERATION;
                    end
                end
            end
            OUTPUT_GENERATION: begin
                counter <= counter + 1;
                if (counter == 3) begin
                    // Round result
                    guard_bit <= product[0];
                    round_bit <= product[1];
                    sticky <= |product[2:0];
                    if (round_bit || (guard_bit && sticky)) begin
                        z_mantissa <= z_mantissa + 1;
                    end
                    // Check for overflow/underflow
                    if (z_exponent > 9'd254) begin
                        z_exponent <= 9'd255;
                        z_mantissa <= 23'd0;
                    end else if (z_exponent < 9'd1) begin
                        z_exponent <= 0;
                        z_mantissa <= 0;
                    end
                    // Format output
                    z <= {z_sign, z_exponent, z_mantissa};
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule