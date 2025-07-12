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
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] cnt; // 0 to 8 iterations
    reg [16:0] SR; // {partial remainder [16:8] (9 bits), quotient [7:0] (8 bits)}
    reg [8:0] divisor_abs; // 9-bit divisor absolute value
    reg [7:0] dividend_abs; // 8-bit dividend absolute value

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    // Intermediate wires for subtraction result
    reg signed [9:0] pr;         // partial remainder signed (9 bits extended to 10 bits)
    reg signed [9:0] sub_res;    // subtraction result: pr - divisor_abs
    reg [8:0] pr_next;           // next partial remainder after restore or no restore

    // Temporary variables to avoid procedural declaration inside always block
    reg [7:0] quotient_next;
    reg [8:0] pr_shifted;        // partial remainder shifted left by 1 bit, inserted with next dividend bit (always 0 here since we do restoring)

    integer i;

    // Capture partial remainder and quotient for easy access
    // Partial remainder stored in SR[16:8] (9 bits)
    // Quotient stored in SR[7:0] (8 bits)
    always @(*) begin
        pr = $signed({1'b0, SR[16:8]}); // extend to 10 bits with zero sign bit
    end

    // Main FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Determine signs and compute absolute values
                        if (sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 1'b1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if (sign && divisor[7]) begin
                            divisor_abs <= {1'b0, (~divisor) + 1'b1};
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= {1'b0, divisor};
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize shift register: partial remainder = dividend_abs shifted left by 1 bit, quotient zero
                        // SR = {partial remainder[8:0], quotient[7:0]}
                        // partial remainder = dividend_abs (8 bits) shifted left by 1 => 9 bits
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;
                    end
                end

                RUN: begin
                    // Perform one iteration of restoring division

                    // Shift partial remainder left by 1 bit, bring in quotient MSB=0 from dividend_abs shifted earlier
                    pr_shifted = {SR[15:8], SR[7]};
                    // Actually, since we store quotient in SR[7:0], quotient bits shift left at the end
                    // But restoring division shifts SR left by 1:
                    // So:
                    // New partial remainder = (old partial remainder <<1) with MSB from quotient shift, which is bit 7 of SR
                    // For our 17-bit SR, shifting left by 1 bit means:
                    // SR << 1 = {SR[15:0], 1'b0}
                    // But we must separate partial remainder and quotient to handle subtraction

                    // But to keep it clear, let's first shift left by 1 bit logically:
                    // partial remainder shifted left by 1 = SR[16:8] << 1, insert quotient's MSB
                    // quotient shifted left by 1 (bits 6 downto 0), insert new bit at LSB later

                    // To keep it consistent, do the following:
                    // Compute pr_shifted = (partial remainder << 1) | next dividend bit (always zero since fixed dividend)
                    // Actually, we don't have any next dividend bit since division is by shifting quotient bits; dividend fixed.

                    // Instead, follow standard restoring division:
                    // subtract divisor_abs from partial remainder shifted left by 1 bit

                    // Shift SR left by 1 bit:
                    // Then subtract divisor_abs

                    // Let's calculate the shifted partial remainder:
                    // partial remainder before shift: SR[16:8] (9 bits)
                    // after shift left by 1: bits [16:9] = SR[15:8], bit 8 = SR[7] (MSB of quotient)

                    // But to be exact, let's implement shift left by 1 on SR first, then subtraction:

                    // Shift SR left by 1 bit:
                    SR <= {SR[15:0], 1'b0};

                    // Now subtract divisor_abs from upper 9 bits:
                    // partial remainder after shift is SR[16:8]

                    // So we subtract divisor_abs from SR[16:8]

                    // Because subtraction result is signed, extend to 10 bits:
                    sub_res = $signed({1'b0, SR[16:8]}) - $signed(divisor_abs);

                    // If sub_res >= 0, keep sub_res and set quotient LSB = 1
                    // Else restore by adding back divisor_abs and set quotient LSB = 0

                    if (sub_res >= 0) begin
                        // Update partial remainder upper bits with sub_res[8:0]
                        SR[16:8] <= sub_res[8:0];
                        SR[0] <= 1'b1;
                    end else begin
                        // Restore partial remainder: add divisor_abs back (no change needed because we have not assigned sub_res)
                        // quotient bit = 0
                        SR[16:8] <= SR[16:8]; // restore no change needed
                        SR[0] <= 1'b0;
                    end

                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // After 8 iterations done, apply sign corrections and output

                    // Extract quotient and remainder
                    // quotient = SR[7:0]
                    // remainder = SR[16:9] (9 bits), but remainder fits in 8 bits (we only use 8 bits)
                    // So remainder is SR[16:9]

                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    quotient_raw = SR[7:0];
                    remainder_raw = SR[16:9];

                    // Signed division corrections
                    if (sign) begin
                        // Quotient sign correction
                        if (quotient_neg)
                            quotient_corr = (~quotient_raw) + 1'b1;
                        else
                            quotient_corr = quotient_raw;

                        // Remainder sign correction
                        if (remainder_neg)
                            remainder_corr = (~remainder_raw) + 1'b1;
                        else
                            remainder_corr = remainder_raw;
                    end else begin
                        quotient_corr = quotient_raw;
                        remainder_corr = remainder_raw;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;

                    cnt <= 4'd0;
                end

                default: begin
                    // Should never happen, reset to IDLE
                    state <= IDLE;
                    cnt <= 4'd0;
                    SR <= 17'd0;
                    res_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (opn_valid) next_state = RUN;
                else next_state = IDLE;
            end

            RUN: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end

            DONE: begin
                // Wait for res_valid to be consumed (not implemented explicitly), 
                // for this simplified module just go back to IDLE
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule