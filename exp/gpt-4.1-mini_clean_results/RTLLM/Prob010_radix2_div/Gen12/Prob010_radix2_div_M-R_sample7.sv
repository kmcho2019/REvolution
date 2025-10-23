module radix2_div (
    input              clk,
    input              rst,
    input              sign,           // 1: signed, 0: unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [7:0] dividend_r, divisor_r;
    reg        dividend_neg, divisor_neg;
    reg [7:0] abs_dividend, abs_divisor;

    reg [3:0] cnt;               // division step counter (1 to 8)
    reg [8:0] remainder;         // 9 bits to hold remainder during division
    reg [7:0] quotient;          // 8 bits quotient

    wire [8:0] sub_result;
    wire       sub_borrow;

    // Prepare negated divisor for subtraction: remainder - divisor
    // Since remainder and divisor are unsigned, subtract directly and detect borrow
    assign {sub_borrow, sub_result} = {1'b0, remainder} - {1'b0, abs_divisor};

    // Next values for remainder and quotient after one division step
    wire [8:0] remainder_next = sub_borrow ? remainder : sub_result;
    wire       quotient_bit = ~sub_borrow;  // 1 if subtraction successful else 0

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            dividend_r    <= 8'b0;
            divisor_r     <= 8'b0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            abs_dividend  <= 8'b0;
            abs_divisor   <= 8'b0;
            cnt           <= 4'b0;
            remainder     <= 9'b0;
            quotient      <= 8'b0;
            res_valid     <= 1'b0;
            result        <= 16'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch inputs and compute abs and sign
                        dividend_r   <= dividend;
                        divisor_r    <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            abs_dividend <= dividend[7] ? (~dividend + 1'b1) : dividend;
                            abs_divisor  <= divisor[7] ? (~divisor + 1'b1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor  <= divisor;
                        end

                        // Initialize remainder and quotient
                        remainder <= 9'b0;
                        quotient  <= {abs_dividend};  // Load dividend in quotient initially

                        cnt <= 4'd1;
                    end
                end

                DIVIDE: begin
                    // Perform division step
                    remainder <= remainder_next;
                    quotient  <= {quotient[6:0], quotient_bit}; // shift left and insert quotient_bit at LSB

                    if (cnt == 4'd8) begin
                        cnt <= 4'd0;
                    end else begin
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    res_valid <= 1'b1;
                end

                default: ; // do nothing
            endcase

            // Output logic and next state FSM logic combined outside for clarity
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if (!res_valid || opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Output assignment and sign correction in combinational block
    // This logic uses registered signals only, so no syntax error
    always @(*) begin
        if (state == DONE) begin
            // Final raw remainder and quotient:
            // remainder is 9-bit, quotient is 8-bit
            // After final step, remainder shifted correctly
            // According to problem, remainder in upper 8 bits, quotient in lower 8 bits

            // Truncate remainder to 8 bits by discarding LSB (the extra bit used during shift)
            // remainder[8:1] is the final remainder
            // quotient is already 8 bits

            reg [7:0] raw_remainder;
            reg [7:0] raw_quotient;
            reg       quotient_neg;
            reg       remainder_neg;

            raw_remainder = remainder[8:1];
            raw_quotient  = quotient;

            quotient_neg = sign & (dividend_neg ^ divisor_neg);
            remainder_neg = sign & dividend_neg;

            if (quotient_neg)
                raw_quotient = (~raw_quotient) + 1'b1;
            if (remainder_neg)
                raw_remainder = (~raw_remainder) + 1'b1;

            result = {raw_remainder, raw_quotient};
        end else begin
            result = 16'b0;
        end
    end

endmodule