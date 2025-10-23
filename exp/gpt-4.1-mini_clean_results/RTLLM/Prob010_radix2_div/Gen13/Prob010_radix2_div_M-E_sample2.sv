module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg [15:0]   result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        DIVIDE  = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers for absolute values and signs
    reg [7:0] dividend_abs, divisor_abs;
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    // Iteration counter
    reg [3:0] count;

    // Registers for remainder and quotient
    reg [8:0] remainder;      // 9 bits to hold remainder + extra bit for subtraction
    reg [7:0] quotient;

    // Next values (combinational)
    reg [8:0] remainder_next;
    reg [7:0] quotient_next;
    reg [3:0] count_next;
    reg       res_valid_next;

    // Subtraction wires
    wire [8:0] sub_result;
    wire       sub_neg;

    // Current divisor extended to 9 bits
    wire [8:0] divisor_ext = {1'b0, divisor_abs};

    // Subtract divisor from remainder
    assign sub_result = remainder - divisor_ext;
    assign sub_neg = sub_result[8];  // sign bit of 9-bit subtraction, 1 means negative result

    // Input latching
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg<= 1'b0;
            remainder_neg<= 1'b0;
            remainder   <= 9'd0;
            quotient    <= 8'd0;
            count       <= 4'd0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    if(opn_valid) begin
                        // Calculate abs and signs for signed operation
                        if(sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 8'd1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if(sign && divisor[7]) begin
                            divisor_abs <= (~divisor) + 8'd1;
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= divisor;
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg<= sign && dividend[7];

                        remainder <= 9'd0;
                        quotient <= 8'd0;
                        count <= 4'd0;
                        res_valid <= 1'b0;
                    end
                end

                DIVIDE: begin
                    // Update remainder, quotient, count from combinational logic
                    remainder <= remainder_next;
                    quotient  <= quotient_next;
                    count     <= count_next;
                    res_valid <= 1'b0;
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Outputs updated below
                end
            endcase

            // Output update at DONE
            if(state == DONE) begin
                // Correct quotient sign if needed
                reg [7:0] corrected_quotient;
                reg [7:0] corrected_remainder;

                // Quotient correction (two's complement if negative)
                corrected_quotient = quotient_neg ? ((~quotient) + 8'd1) : quotient;
                // Remainder correction (two's complement if negative)
                corrected_remainder = remainder_neg ? ((~remainder[7:0]) + 8'd1) : remainder[7:0];

                result <= {corrected_remainder, corrected_quotient};
            end else if(state == IDLE) begin
                result <= 16'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(opn_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if(count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if(opn_valid)
                    next_state = DIVIDE;
            end
        endcase
    end

    // Combinational logic for next remainder, quotient, count during DIVIDE
    always @(*) begin
        remainder_next = remainder;
        quotient_next = quotient;
        count_next = count;

        if(state == DIVIDE) begin
            // Shift left (remainder, quotient) combined by 1 bit:
            // - remainder shifts left by 1, bringing in next dividend_abs bit from MSB side
            // - quotient shifts left by 1, quotient LSB to be set based on subtraction result

            // Extract next dividend bit to bring into remainder LSB:
            // The dividend bits are shifted out MSB first over 8 cycles
            // On iteration i (0-based), bring down dividend_abs[7 - count]

            reg [7:0] dividend_shift_bit_index;
            dividend_shift_bit_index = 7 - count;

            reg next_dividend_bit;
            next_dividend_bit = dividend_abs[dividend_shift_bit_index];

            reg [8:0] rem_shifted = {remainder[7:0], next_dividend_bit}; // Shift left remainder and bring next dividend bit

            // Attempt subtract divisor
            reg [8:0] sub_res_tmp;
            sub_res_tmp = rem_shifted - divisor_ext;

            if(!sub_res_tmp[8]) begin
                // Subtraction successful (non-negative)
                remainder_next = sub_res_tmp;
                quotient_next = {quotient[6:0], 1'b1};
            end else begin
                // Subtraction failed (negative)
                remainder_next = rem_shifted;
                quotient_next = {quotient[6:0], 1'b0};
            end

            count_next = count + 1'b1;
        end
    end

endmodule