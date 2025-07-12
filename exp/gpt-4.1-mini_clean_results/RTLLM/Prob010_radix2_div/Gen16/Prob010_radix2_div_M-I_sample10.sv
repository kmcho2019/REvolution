module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result          // [15:8] remainder, [7:0] quotient
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    reg [3:0] cnt;            // counts 0 to 8
    reg [16:0] SR;            // {partial_remainder[16:8], quotient[7:0]}
    reg [8:0] divisor_abs;    // absolute value of divisor (9 bits)
    reg [7:0] dividend_abs;   // absolute value of dividend (8 bits)

    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    reg opn_start;

    // Handle division by zero: we treat divisor_abs == 0 as special case
    wire divisor_is_zero = (divisor_abs == 9'd0);

    // Inline absolute value computation for signed inputs
    wire [7:0] dividend_abs_w = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [8:0] divisor_abs_w  = (sign && divisor[7]) ? {1'b0, (~divisor + 8'd1)} : {1'b0, divisor};

    // Signals for subtraction during division iterations
    wire signed [9:0] remainder_part = {1'b0, SR[16:8]};      // 9 bits partial remainder, zero-extended to 10 bits
    wire signed [9:0] divisor_10     = {1'b0, divisor_abs};
    wire signed [9:0] sub_res = remainder_part - divisor_10;

    // Next SR and cnt combinational signals
    reg [16:0] SR_next;
    reg [3:0] cnt_next;

    // Output wires for signed quotient and remainder correction
    wire [7:0] quotient_raw = SR[7:0];
    wire [7:0] remainder_raw = SR[16:9];

    wire [7:0] quotient_signed = quotient_neg ? (~quotient_raw + 8'd1) : quotient_raw;
    wire [7:0] remainder_signed = remainder_neg ? (~remainder_raw + 8'd1) : remainder_raw;

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            cnt <= 4'd0;
            SR <= 17'd0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            opn_start <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && !res_valid && !opn_start) begin
                        // Latch inputs and compute abs values
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg <= (sign && divisor[7]);

                        dividend_abs <= dividend_abs_w;
                        divisor_abs <= divisor_abs_w;

                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Initialize SR with partial remainder = dividend_abs shifted left by 1 bit (9 bits)
                        // Quotient initially zero
                        // SR layout: [16:8] partial remainder (9 bits), [7:0] quotient (8 bits)
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;
                        opn_start <= 1'b1;
                    end else if (!opn_valid) begin
                        opn_start <= 1'b0; // ready for next opn_valid
                    end
                end

                DIVIDE: begin
                    SR <= SR_next;
                    cnt <= cnt_next;
                end

                DONE: begin
                    // Output the signed corrected quotient and remainder
                    res_valid <= 1'b1;
                    // Compose result: remainder (signed corrected) upper 8 bits, quotient (signed corrected) lower 8 bits
                    result <= {remainder_signed, quotient_signed};
                end

                default: begin
                    res_valid <= 1'b0;
                end
            endcase

            // Clear res_valid when new operation starts
            if ((state == DONE) && (opn_valid && !res_valid)) begin
                res_valid <= 1'b0;
            end
        end
    end

    // FSM next state and combinational logic
    always @(*) begin
        next_state = state;
        SR_next = SR;
        cnt_next = cnt;

        case (state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end

            DIVIDE: begin
                // Handle divisor zero: immediately jump to DONE with quotient=0 and remainder=dividend
                if (divisor_is_zero) begin
                    // Set quotient=0, remainder=dividend_abs (with sign correction applied outside)
                    SR_next = {dividend_abs, 8'd0};
                    cnt_next = 4'd8; // finish iteration
                    next_state = DONE;
                end else begin
                    // Normal division iteration step
                    // Shift SR left by 1 bit
                    // Then try to subtract divisor_abs from upper 9 bits of SR
                    // If subtraction >= 0, update remainder part and set quotient LSB to 1
                    // Else restore remainder (no subtraction) and set quotient LSB to 0

                    reg [16:0] SR_shifted;
                    SR_shifted = {SR[15:0], 1'b0};

                    if (sub_res >= 0) begin
                        // subtraction successful: update remainder and set quotient bit = 1
                        SR_next = SR_shifted;
                        SR_next[16:8] = sub_res[8:0];   // update remainder
                        SR_next[0] = 1'b1;              // quotient bit after shift = 1
                    end else begin
                        // subtraction failed: restore remainder, quotient bit = 0 (already zero after shift)
                        SR_next = SR_shifted;
                        // quotient LSB remains 0
                    end

                    cnt_next = cnt + 1'b1;

                    if (cnt_next == 4'd8)
                        next_state = DONE;
                    else
                        next_state = DIVIDE;
                end
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule