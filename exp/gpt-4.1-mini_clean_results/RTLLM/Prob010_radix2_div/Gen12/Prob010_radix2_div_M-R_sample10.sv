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

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers for sign and absolute values
    reg dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;
    reg quotient_neg, remainder_neg;

    // Shift register: {remainder[8:0], quotient[7:0]} = 17 bits total
    reg [16:0] SR, next_SR;
    reg [3:0] cnt, next_cnt;

    // Extended divisor to 9 bits for subtraction
    reg [8:0] divisor_ext;

    // Wires for combinational subtraction
    wire [9:0] sub_res;
    wire borrow;

    // Extract remainder part from SR
    wire [8:0] remainder = SR[16:8];
    // Extract quotient part from SR
    wire [7:0] quotient = SR[7:0];

    // Compute subtraction remainder - divisor_ext
    assign sub_res = {1'b0, remainder} - {1'b0, divisor_ext};
    assign borrow = sub_res[9]; // borrow is 1 if subtraction fails

    // Combinational logic to compute next_SR and next_cnt during DIVIDE
    always @(*) begin
        // Default next values
        next_SR = SR;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                next_SR = SR;
                next_cnt = 4'd0;
            end
            DIVIDE: begin
                // Shift left SR by 1 bit first:
                // The new remainder candidate after shift is (remainder<<1) concatenated with highest quotient bit
                // But simpler: shift entire SR by 1 bit left
                // Then try to subtract divisor_ext from new remainder
                // Depending on borrow, update remainder and quotient LSB accordingly
                reg [16:0] SR_shifted;
                reg [8:0] rem_shifted, rem_sub;

                SR_shifted = SR << 1;
                rem_shifted = SR_shifted[16:8]; // upper 9 bits after shift

                rem_sub = rem_shifted - divisor_ext;

                if(rem_sub[8] == 1'b0) begin
                    // Subtraction success: update remainder with subtraction result and set quotient bit to 1
                    next_SR = {rem_sub, SR_shifted[7:1], 1'b1};
                end else begin
                    // Subtraction fails: keep remainder as rem_shifted, quotient bit 0
                    next_SR = {rem_shifted, SR_shifted[7:1], 1'b0};
                end

                next_cnt = cnt + 1'b1;
            end
            DONE: begin
                next_SR = SR;
                next_cnt = cnt;
            end
        endcase
    end

    // FSM state transitions
    always @(*) begin
        case(state)
            IDLE: next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE: next_state = (opn_valid) ? DIVIDE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, SR, sign extraction
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            SR <= 17'd0;
            cnt <= 4'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            divisor_ext <= 9'd0;
            result <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if(opn_valid) begin
                        // Determine sign and absolute values
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
                        remainder_neg <= sign && dividend[7];

                        divisor_ext <= {1'b0, divisor_abs};

                        // Initialize SR: remainder=0, quotient=dividend_abs
                        // We put quotient into lower 8 bits, remainder into upper 9 bits zeroed
                        SR <= {9'd0, dividend_abs};

                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    // Update shift register and counter
                    SR <= next_SR;
                    cnt <= next_cnt;
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Keep SR stable
                end
            endcase

            // When starting a new operation during DONE or IDLE, clear res_valid
            if((state == DONE || state == IDLE) && opn_valid && (state != DIVIDE))
                res_valid <= 1'b0;
        end
    end

    // Corrected quotient and remainder after division (signed correction)
    // Extract raw quotient and remainder (remainder is 9 bits, but final remainder is 8 bits)
    wire [7:0] raw_quotient = SR[7:0];
    wire [8:0] raw_remainder = SR[16:8];

    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    always @(*) begin
        if(res_valid) begin
            // Correct quotient sign
            if(quotient_neg)
                corrected_quotient = (~raw_quotient) + 8'd1;
            else
                corrected_quotient = raw_quotient;

            // Correct remainder sign
            // Use only lower 8 bits of remainder (the 9th bit can be overflow from shift)
            if(remainder_neg)
                corrected_remainder = (~raw_remainder[7:0]) + 8'd1;
            else
                corrected_remainder = raw_remainder[7:0];
        end else begin
            corrected_quotient = 8'd0;
            corrected_remainder = 8'd0;
        end
    end

    // Update output result register in DONE state
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            result <= 16'd0;
        end else if(state == DONE) begin
            result <= {corrected_remainder, corrected_quotient};
        end
    end

endmodule