module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    reg [3:0] cnt;           // iteration counter (0-8)
    reg [16:0] SR;           // shift register: {partial remainder[16:8], quotient[7:0]}
    reg [8:0] divisor_abs;   // 9-bit absolute divisor (with leading 0)
    reg [7:0] dividend_abs;  // 8-bit absolute dividend

    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    // Wires for subtraction and sign extension
    wire signed [9:0] remainder_signed = {1'b0, SR[16:8]};
    wire signed [9:0] divisor_signed = {1'b0, divisor_abs};
    wire signed [9:0] sub_result = remainder_signed - divisor_signed;

    // Next SR and cnt registers
    reg [16:0] SR_next;
    reg [3:0] cnt_next;

    // Sign correction registers
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Helper function to get absolute value
    function [7:0] abs8;
        input [7:0] val;
        input       sign_flag;
        begin
            if (sign_flag && val[7]) // negative number
                abs8 = (~val) + 8'd1;
            else
                abs8 = val;
        end
    endfunction

    // Helper function to get absolute value 9 bits
    function [8:0] abs9;
        input [7:0] val;
        input       sign_flag;
        begin
            if (sign_flag && val[7])
                abs9 = {1'b0, (~val) + 8'd1};
            else
                abs9 = {1'b0, val};
        end
    endfunction

    // Sequential logic for FSM and main operations
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
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Compute absolute values and track signs
                        dividend_neg <= sign && dividend[7];
                        divisor_neg <= sign && divisor[7];
                        dividend_abs <= abs8(dividend, sign);
                        divisor_abs <= abs9(divisor, sign);

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize SR:
                        // Partial remainder = dividend_abs shifted left by 1 bit (9 bits)
                        // Quotient zeroed
                        SR <= {dividend_abs, 1'b0, 8'd0}; // {dividend_abs[7:0],1'b0} = 9 bits partial remainder
                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    // Shift SR left by 1 bit
                    // SR after shift left: {SR[15:0], 1'b0}
                    // Perform subtraction on upper 9 bits (partial remainder)
                    // If subtraction >=0, update remainder and set quotient LSB=1
                    // Else restore and set quotient LSB=0

                    SR <= SR_next;
                    cnt <= cnt_next;
                end

                DONE: begin
                    // Apply sign correction on quotient and remainder

                    quotient_raw <= SR[7:0];
                    remainder_raw <= SR[16:9];

                    // Sign correction applied combinationally below
                    res_valid <= 1'b1;
                    result <= {
                        (remainder_neg) ? ((~SR[16:9]) + 8'd1) : SR[16:9],
                        (quotient_neg) ? ((~SR[7:0]) + 8'd1) : SR[7:0]
                    };

                    cnt <= 4'd0;
                end

                default: begin
                    // default to IDLE
                    state <= IDLE;
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    SR <= 17'd0;
                end
            endcase
        end
    end

    // Combinational next state and data path logic
    always @(*) begin
        next_state = state;
        SR_next = SR;
        cnt_next = cnt;

        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end

            DIVIDE: begin
                // Shift left by 1 bit
                // Compute tentative remainder after subtraction
                // Step 1: shift SR left by 1 bit
                // Since SR = {partial remainder[16:8], quotient[7:0]} (17 bits)
                // Shift left: {SR[15:0],1'b0}

                reg [16:0] SR_shifted;
                reg signed [9:0] sub_res;

                SR_shifted = {SR[15:0], 1'b0};
                sub_res = $signed({1'b0, SR_shifted[16:8]}) - $signed(divisor_abs);

                if (sub_res >= 0) begin
                    // Update remainder with subtraction result and set quotient LSB to 1
                    SR_next = SR_shifted;
                    SR_next[16:8] = sub_res[8:0];
                    SR_next[0] = 1'b1; // quotient LSB after shift
                end else begin
                    // Restore remainder (keep after shift) and set quotient LSB to 0
                    SR_next = SR_shifted;
                    // Partial remainder unchanged because subtraction failed
                    // Quotient LSB = 0 (already zero after shift)
                    // SR_next[0] is zero by shift, so no change needed
                end

                cnt_next = cnt + 1'b1;

                if (cnt_next == 4'd8)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            end

            DONE: begin
                // After res_valid asserted for 1 cycle, go back to IDLE
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule