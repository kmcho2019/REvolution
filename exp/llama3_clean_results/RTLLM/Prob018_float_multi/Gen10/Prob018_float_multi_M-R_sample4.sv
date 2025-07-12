module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Enumerated type for state machine
    enum logic [2:0] {IDLE, INPUT_PROCESSING, SPECIAL_CASES_HANDLING, MULTIPLICATION_AND_EXPONENT_ADJUSTMENT, ROUNDING_AND_OUTPUT_FORMATTING} state, next_state;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa;
    reg [8:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;
    reg [1:0] round_mode;

    // LUT for rounding
    always @(*) begin
        case ({guard_bit, round_bit, sticky})
            3'b000: round_mode = 2'b00; // Round towards zero
            3'b001: round_mode = 2'b01; // Round up
            3'b010: round_mode = 2'b10; // Round down
            3'b011: round_mode = 2'b11; // Round towards zero
            3'b100: round_mode = 2'b01; // Round up
            3'b101: round_mode = 2'b01; // Round up
            3'b110: round_mode = 2'b10; // Round down
            3'b111: round_mode = 2'b10; // Round down
        endcase
    end

    // State machine
    always @(*) begin
        case (state)
            IDLE: begin
                if (rst) begin
                    next_state = IDLE;
                end else begin
                    next_state = INPUT_PROCESSING;
                end
            end
            INPUT_PROCESSING: begin
                next_state = SPECIAL_CASES_HANDLING;
            end
            SPECIAL_CASES_HANDLING: begin
                if ((a_exponent == 9'h1ff && a_mantissa != 0) || (b_exponent == 9'h1ff && b_mantissa != 0)) begin
                    // NaN
                    next_state = ROUNDING_AND_OUTPUT_FORMATTING;
                end else if ((a_exponent == 9'h1ff && a_mantissa == 0) || (b_exponent == 9'h1ff && b_mantissa == 0)) begin
                    // Infinity
                    next_state = ROUNDING_AND_OUTPUT_FORMATTING;
                end else begin
                    next_state = MULTIPLICATION_AND_EXPONENT_ADJUSTMENT;
                end
            end
            MULTIPLICATION_AND_EXPONENT_ADJUSTMENT: begin
                next_state = ROUNDING_AND_OUTPUT_FORMATTING;
            end
            ROUNDING_AND_OUTPUT_FORMATTING: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            a_mantissa <= 0;
            a_exponent <= 0;
            a_sign <= 0;
            b_mantissa <= 0;
            b_exponent <= 0;
            b_sign <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
        end else begin
            state <= next_state;
            case (state)
                INPUT_PROCESSING: begin
                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    a_sign <= a[31];
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];
                    b_sign <= b[31];
                end
                SPECIAL_CASES_HANDLING: begin
                    if ((a_exponent == 9'h1ff && a_mantissa != 0) || (b_exponent == 9'h1ff && b_mantissa != 0)) begin
                        // NaN
                        z <= 32'h7fc00000;
                    end else if ((a_exponent == 9'h1ff && a_mantissa == 0) || (b_exponent == 9'h1ff && b_mantissa == 0)) begin
                        // Infinity
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end
                end
                MULTIPLICATION_AND_EXPONENT_ADJUSTMENT: begin
                    // Booth multiplier
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    // Exponent adjustment
                    z[30:23] <= a_exponent + b_exponent - 9'h7f;
                    z[31] <= a_sign ^ b_sign;
                end
                ROUNDING_AND_OUTPUT_FORMATTING: begin
                    // Calculate guard, round, and sticky bits
                    guard_bit <= product[24];
                    round_bit <= product[25];
                    sticky <= |product[26:0];

                    // Perform rounding
                    case (round_mode)
                        2'b01: begin
                            // Round up
                            z[22:0] <= product[47:25] + 1;
                        end
                        2'b10: begin
                            // Round down
                            z[22:0] <= product[47:25];
                        end
                        2'b11: begin
                            // Round towards zero
                            z[22:0] <= product[47:25];
                        end
                    endcase
                end
            endcase
        end
    end
endmodule