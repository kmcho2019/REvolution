module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1: signed division, 0: unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result           // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum reg [1:0] {IDLE=2'd0, RUN=2'd1, DONE=2'd2} state_t;
    state_t state, next_state;

    reg [3:0] cnt;                 // counts division steps (0..8)
    reg [16:0] SR;                 // Shift register: [16:8]=remainder (9 bits), [7:0]=quotient
    reg [7:0] abs_dividend, abs_divisor;
    reg dividend_neg, divisor_neg;

    wire [8:0] rem = SR[16:8];
    wire [8:0] sub_res;
    wire borrow;
    assign {borrow, sub_res} = {1'b0, rem} - {1'b0, abs_divisor};

    // State transitions
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? RUN : IDLE;
            RUN:    next_state = (cnt == 4'd8) ? DONE : RUN;
            DONE:   next_state = (opn_valid) ? RUN : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential FSM and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            cnt         <= 4'd0;
            SR          <= 17'd0;
            abs_dividend<= 8'd0;
            abs_divisor <= 8'd0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            result      <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Record signs
                        dividend_neg <= sign & dividend[7];
                        divisor_neg  <= sign & divisor[7];
                        // Compute absolute values
                        abs_dividend <= (sign & dividend[7]) ? (~dividend + 1'b1) : dividend;
                        abs_divisor  <= (sign & divisor[7])  ? (~divisor + 1'b1)  : divisor;
                        // Initialize SR: remainder=0, quotient=abs_dividend
                        SR <= {9'd0, (sign & dividend[7]) ? (~dividend + 1'b1) : dividend};
                    end
                end

                RUN: begin
                    cnt <= cnt + 1'b1;
                    // Shift left SR by 1 bit (remainder + quotient)
                    // Then subtract divisor from remainder and decide quotient bit
                    if (~borrow) begin
                        // Subtract succeeded: update remainder to sub_res and set quotient bit =1
                        // After shift left by 1: SR_next = {sub_res, quotient shifted, LSB=1}
                        SR <= {sub_res, SR[7:0], 1'b1} << 1 >> 1; // Shift left 1 bit, set LSB=1 without extra shift
                        // Above operation is equivalent to:
                        // temp = SR << 1; then replace remainder bits and set quotient LSB=1
                        // To do it clearly:
                        // shift SR left 1: temp = SR << 1;
                        // then SR[16:8] = sub_res; SR[0]=1;
                        // SR[7:1] = temp[7:1];
                        // But for simplicity, do in next clock cycle combinationally below.
                    end else begin
                        // Subtract failed: remainder unchanged, shift quotient LSB=0
                        // After shift left by 1, remainder stays the same, quotient LSB=0
                        SR <= {rem, SR[7:0], 1'b0} << 1 >> 1;
                    end
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Result assigned below in combinational block
                end
            endcase
        end
    end

    // Correct SR update during RUN state - combinational approach on posedge clk:
    // To ensure proper updates of remainder and quotient bits after shift
    always @(posedge clk) begin
        if (!rst && state == RUN) begin
            // Shift left by 1:
            // temp_SR = SR << 1;
            // If subtraction succeeded: update remainder part to sub_res and quotient bit =1
            // else remainder unchanged and quotient bit=0
            reg [16:0] temp_SR;
            temp_SR = SR << 1;
            if (~borrow) begin
                // Replace remainder bits [16:8] with sub_res, set quotient bit 0 =1
                SR <= {sub_res, temp_SR[7:1], 1'b1};
            end else begin
                // Keep remainder bits [16:8], quotient bit 0 =0
                SR <= {rem, temp_SR[7:1], 1'b0};
            end
        end
    end

    // Combinational block to assign result in DONE state with correct sign adjustment
    always @(*) begin
        if (state == DONE) begin
            reg [7:0] quotient_raw, remainder_raw;
            reg quotient_sign, remainder_sign;
            reg [7:0] quotient_final, remainder_final;

            quotient_raw = SR[7:0];
            remainder_raw = SR[16:9]; // Top 8 bits of remainder (discard extra bit 8)
            quotient_sign = sign & (dividend_neg ^ divisor_neg);
            remainder_sign = sign & dividend_neg;

            // Adjust quotient sign
            if (quotient_sign)
                quotient_final = (~quotient_raw + 1'b1);
            else
                quotient_final = quotient_raw;

            // Adjust remainder sign
            if (remainder_sign)
                remainder_final = (~remainder_raw + 1'b1);
            else
                remainder_final = remainder_raw;

            result = {remainder_final, quotient_final};
        end else begin
            result = 16'd0;
        end
    end

endmodule