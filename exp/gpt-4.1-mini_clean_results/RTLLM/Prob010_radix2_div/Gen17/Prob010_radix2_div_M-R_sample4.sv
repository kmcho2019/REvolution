module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers for inputs processing
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg dividend_sign;
    reg divisor_sign;

    // Working registers for division
    reg [15:0] sr;         // Shift register: upper 8 bits remainder, lower 8 bits quotient
    reg [7:0] divisor_neg; // Negative of divisor_abs
    reg [3:0] cnt;         // Counter for division steps (0 to 8)

    // Combinational signals for abs and neg
    wire [7:0] dividend_abs_w;
    wire [7:0] divisor_abs_w;

    wire dividend_sign_w;
    wire divisor_sign_w;

    // Compute absolute values combinationally
    assign dividend_sign_w = sign & dividend[7];
    assign divisor_sign_w  = sign & divisor[7];

    assign dividend_abs_w = dividend_sign_w ? (~dividend + 1) : dividend;
    assign divisor_abs_w  = divisor_sign_w  ? (~divisor + 1)  : divisor;

    // Compute negation of divisor_abs
    wire [7:0] divisor_neg_w = ~divisor_abs + 1;

    // Temporary subtraction result (9-bit for borrow)
    reg [8:0] sub_res;

    // Quotient bit computed this cycle
    reg q_bit;

    // Next sr candidate after subtraction decision
    reg [15:0] sr_next;

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid) next_state = CALC;
                else next_state = IDLE;
            end
            CALC: begin
                if (cnt == 4'd8) next_state = DONE;
                else next_state = CALC;
            end
            DONE: begin
                if (opn_valid) next_state = CALC; // new operation start
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Division step combinational logic (used in CALC state)
    always @(*) begin
        // Default no change
        sub_res = 9'd0;
        q_bit = 1'b0;
        sr_next = sr;

        if (state == CALC) begin
            // Shift left sr by 1: upper remainder (sr[15:8]), lower quotient (sr[7:0])
            // Bring next dividend bit down via shifting in sr[15] from sr[14]
            // We'll shift sr left by 1 bit to process one division step

            // Upper 9 bits are remainder+next dividend bit
            // remainder is sr[15:8], quotient is sr[7:0]
            // Step 1: Shift remainder left 1 and bring down msb of quotient

            // Prepare tentative remainder: remainder shifted left, with next bit of quotient
            // Here, quotient bits move right, so the remainder is shifted left
            // For radix-2 divide, we bring down bits from dividend (held in quotient register initially) to remainder each step
            // But in original implementation dividend is shifted left into sr. Here sr holds remainder (upper 8) and quotient (lower 8)
            // The dividend is fed initially as abs(dividend) shifted left 8 bits (lowest 8 bits zero)
            // So shifting sr left by 1 each step brings new dividend bits into remainder part

            // Let's simulate this: shift sr left 1 bit:
            reg [15:0] shifted_sr = sr << 1;

            // tentative remainder = shifted_sr[15:8]
            // subtract divisor_abs: sub_res = tentative_remainder - divisor_abs
            sub_res = {1'b0, shifted_sr[15:8]} - {1'b0, divisor_abs};

            // If sub_res >= 0, q_bit = 1, else 0
            q_bit = ~sub_res[8];

            if (q_bit) begin
                // remainder gets sub_res[7:0]
                sr_next = {sub_res[7:0], shifted_sr[7:1], 1'b1};
            end else begin
                // remainder stays shifted remainder, quotient bit 0
                sr_next = {shifted_sr[15:8], shifted_sr[7:1], 1'b0};
            end
        end else begin
            sr_next = sr;
            q_bit = 1'b0;
            sub_res = 9'd0;
        end
    end

    // Signed result correction combinational logic
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;
    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    always @(*) begin
        quotient_raw = sr[7:0];
        remainder_raw = sr[15:8];

        if (sign) begin
            // quotient sign = dividend_sign ^ divisor_sign
            if ((dividend_sign ^ divisor_sign) == 1'b1)
                quotient_signed = (~quotient_raw) + 1;
            else
                quotient_signed = quotient_raw;

            // remainder sign = dividend_sign
            if (dividend_sign)
                remainder_signed = (~remainder_raw) + 1;
            else
                remainder_signed = remainder_raw;
        end else begin
            quotient_signed = quotient_raw;
            remainder_signed = remainder_raw;
        end
    end

    // Sequential logic: registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            sr          <= 16'd0;
            divisor_abs <= 8'd0;
            divisor_neg <= 8'd0;
            dividend_abs<= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            cnt         <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_abs <= dividend_abs_w;
                        divisor_abs  <= divisor_abs_w;
                        dividend_sign <= dividend_sign_w;
                        divisor_sign  <= divisor_sign_w;

                        // Initialize shift register: dividend_abs in upper 8 bits, quotient 0 in lower 8 bits
                        // According to the original, dividend_abs is shifted left by one bit? We place it as upper bits and zeros below.
                        // Actually, in previous code, dividend_abs was loaded as upper 8 bits, quotient zero, then shifted left during calculation
                        // To simulate same, we place dividend_abs in bits [15:8], zeros in [7:0]
                        sr <= {dividend_abs_w, 8'd0};

                        cnt <= 4'd0;
                    end
                end
                CALC: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: produce max quotient and remainder=dividend_abs immediately and move to DONE
                        sr <= {dividend_abs, 8'hFF};
                        cnt <= 4'd8; // Force completion next cycle
                    end else if (cnt < 4'd8) begin
                        sr <= sr_next;
                        cnt <= cnt + 1'b1;
                    end
                end
                DONE: begin
                    // Output the final result: corrected remainder and quotient
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;

                    if (opn_valid) begin
                        // Start new operation immediately on opn_valid
                        dividend_abs <= dividend_abs_w;
                        divisor_abs  <= divisor_abs_w;
                        dividend_sign <= dividend_sign_w;
                        divisor_sign  <= divisor_sign_w;
                        sr <= {dividend_abs_w, 8'd0};
                        cnt <= 4'd0;
                        res_valid <= 1'b0;
                    end else begin
                        // Keep result valid until new opn_valid or reset
                        res_valid <= 1'b1;
                    end
                end
                default: begin
                    // Should not happen
                    sr <= 16'd0;
                    cnt <= 4'd0;
                    res_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule