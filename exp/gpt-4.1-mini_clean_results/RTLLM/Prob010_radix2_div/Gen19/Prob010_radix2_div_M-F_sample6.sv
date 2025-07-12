module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    input           res_ready,      // Indicates that the consumer has accepted the result
    output reg      res_valid,
    output reg [15:0] result         // { remainder[7:0], quotient[7:0] }
);

    // State machine states
    typedef enum reg [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;

    state_t state;

    // Registers for absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg dividend_sign;
    reg divisor_sign;

    // 17-bit shift register: upper 9 bits remainder, lower 8 bits quotient
    reg [16:0] shift_reg;

    // 4-bit counter for division cycles (0 to 7)
    reg [3:0] count;

    // Variables for subtraction and remainder trial
    wire [8:0] remainder_trial;
    wire [8:0] subtract_res;
    wire       sub_non_neg;

    // Quotient and remainder before sign correction
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Final quotient and remainder after sign correction
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Function: absolute value of 8-bit signed number
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    // Function: 2's complement negation of 8-bit number
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 8'd1;
        end
    endfunction

    // Calculate remainder trial: left shift remainder by 1 and bring down next quotient bit (MSB of quotient)
    // remainder_trial is upper 9 bits of shift_reg shifted left by 1 with the next quotient bit (bit 8 of quotient) at LSB
    assign remainder_trial = {shift_reg[16:9], 1'b0} | (shift_reg[8] ? 9'b1 : 9'b0);
    // Actually, the algorithm: shift_reg is shifted left by 1 each cycle, but to compute subtract_res:
    // remainder_trial = (current_remainder << 1) | next bit from quotient (shift_reg bit 8)
    // But we shift the entire shift_reg by 1 and put the new quotient bit at LSB next cycle.

    // It's cleaner to perform subtraction after shift left by 1 in logic:
    // The subtraction is remainder_trial - divisor_abs

    // To simplify: We perform subtraction trial on remainder after shifting left by 1:
    // But we implement subtraction on (shift_reg[16:9] shifted left 1 plus next quotient bit at LSB)
    // So remainder_trial = {shift_reg[16:9], 1'b0} + shift_reg[8] inserted at LSB - this is the current remainder shifted left by 1 plus the next quotient bit

    // Actually, a simpler approach is:

    // The division step:
    // 1) shift shift_reg left by 1 bit (includes remainder and quotient) --> gives next remainder with one extra zero bit.
    // 2) subtract divisor_abs from the upper 9 bits (new remainder portion).
    // 3) If subtraction >= 0: update remainder to subtraction result and set quotient bit (LSB) = 1.
    //    Else: restore remainder and set quotient bit = 0.

    // So let's pre-calculate subtraction:

    // remainder_trial after left shift by 1 (shift_reg << 1)
    wire [16:0] shift_reg_shifted = shift_reg << 1;

    // Subtract divisor_abs from upper 9 bits of shifted remainder
    assign subtract_res = shift_reg_shifted[16:8] - {1'b0, divisor_abs};
    assign sub_non_neg = ~subtract_res[8]; // MSB 0 means non-negative

    // Next shift_reg update:
    // If sub_non_neg == 1:  
    //    shift_reg_next = {subtract_res[7:0], shift_reg_shifted[7:0], 1'b1}
    // Else
    //    shift_reg_next = {shift_reg_shifted[16:8], shift_reg_shifted[7:0], 1'b0}

    wire [16:0] shift_reg_next = sub_non_neg ? 
                                 {subtract_res[7:0], shift_reg_shifted[7:0], 1'b1} :
                                 {shift_reg_shifted[16:8],  shift_reg_shifted[7:0], 1'b0};

    // We need to ensure the widths match:
    // subtract_res[7:0]: 8 bits (new remainder upper bits)
    // shift_reg_shifted[7:0]: 8 bits (lower quotient bits)
    // plus 1-bit quotient bit at LSB
    // total 8 + 8 + 1 =17 bits.

    // The quotient bit is inserted at LSB of shift_reg_next.

    // On division completion:
    // remainder_raw = upper 8 bits of shift_reg (shift_reg[16:9])
    // quotient_raw = lower 8 bits (shift_reg[7:0])

    // FSM and logic:

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            shift_reg      <= 17'd0;
            count          <= 4'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            quotient_raw   <= 8'd0;
            remainder_raw  <= 8'd0;
            quotient_final <= 8'd0;
            remainder_final<= 8'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch signs and absolute values
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            dividend_abs  <= abs8(dividend);
                            divisor_abs   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            dividend_abs  <= dividend;
                            divisor_abs   <= divisor;
                        end

                        // Initialize shift_reg:
                        // remainder upper 9 bits = 0
                        // quotient lower 8 bits = dividend_abs
                        // Shift left by 1 bit by putting 0 at LSB (equivalent to multiplying dividend by 2)
                        // According to problem description, shift_reg = {9'b0, dividend_abs[7:0], 1'b0}
                        shift_reg <= {9'd0, dividend_abs, 1'b0};

                        count <= 4'd0;

                        if (divisor == 8'd0) begin
                            // Division by zero handled in DONE state
                            state <= DONE;
                        end else begin
                            state <= DIVIDE;
                        end
                    end
                end

                DIVIDE: begin
                    if (count < 4'd8) begin
                        // Execute division step
                        shift_reg <= shift_reg_next;
                        count <= count + 1'b1;
                    end else begin
                        // Division finished
                        quotient_raw  <= shift_reg[7:0];
                        remainder_raw <= shift_reg[16:9];
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Handle division by zero case
                    if (divisor_abs == 8'd0) begin
                        // Quotient = 0xFF, remainder = dividend (absolute or signed)
                        quotient_final  <= 8'hFF;
                        if (sign && dividend_sign)
                            remainder_final <= neg8(dividend_abs);
                        else
                            remainder_final <= dividend_abs;
                    end else begin
                        // Sign correction
                        if (sign) begin
                            // Quotient sign = dividend_sign XOR divisor_sign
                            if (dividend_sign ^ divisor_sign)
                                quotient_final <= neg8(quotient_raw);
                            else
                                quotient_final <= quotient_raw;

                            // Remainder sign = dividend_sign
                            if (dividend_sign)
                                remainder_final <= neg8(remainder_raw);
                            else
                                remainder_final <= remainder_raw;
                        end else begin
                            quotient_final  <= quotient_raw;
                            remainder_final <= remainder_raw;
                        end
                    end

                    // Output result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;

                    // Wait for res_ready to clear and no new operation (opn_valid low)
                    if (res_ready && !opn_valid) begin
                        res_valid <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule