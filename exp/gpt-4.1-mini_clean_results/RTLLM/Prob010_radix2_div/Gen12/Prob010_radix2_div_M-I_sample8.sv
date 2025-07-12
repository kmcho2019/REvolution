module radix2_div (
    input           clk,
    input           rst,
    input           sign,             // 1: signed division, 0: unsigned division
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result          // [15:8]: remainder, [7:0]: quotient
);

    // FSM states
    localparam IDLE    = 2'd0;
    localparam RUN     = 2'd1;
    localparam COMPLETE= 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    reg [15:0] SR;       // Shift register: upper 8 bits remainder, lower 8 bits quotient
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;
    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;
    reg [3:0] cnt;       // 4-bit counter for 8 cycles

    // Signed internal signals for arithmetic
    reg signed [8:0] remainder;       // 9-bit remainder (to hold carry/borrow)
    reg signed [8:0] remainder_sub;   // subtraction result

    // FSM state transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = (opn_valid && !res_valid) ? RUN : IDLE;
            RUN:     next_state = (cnt == 4'd8) ? COMPLETE : RUN;
            COMPLETE:next_state = (res_valid && opn_valid) ? RUN : (res_valid ? COMPLETE : IDLE);
            default: next_state = IDLE;
        endcase
    end

    // Main division process and control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid    <= 1'b0;
            result       <= 16'd0;
            divisor_abs  <= 8'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            SR           <= 16'd0;
            cnt          <= 4'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if(opn_valid && !res_valid) begin
                        // Determine signs and absolute values if signed division
                        if(sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;
                        end

                        quotient_neg  <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize SR: remainder=0 in upper 8 bits, quotient=dividend_abs in lower 8 bits
                        SR <= {8'd0, dividend_abs};
                    end
                end

                RUN: begin
                    cnt <= cnt + 1'b1;

                    // Extract current remainder and quotient
                    remainder <= {1'b0, SR[15:8]}; // 9-bit remainder with zero extend

                    // Subtract divisor_abs from remainder
                    remainder_sub <= remainder - {1'b0, divisor_abs};

                    if (remainder_sub >= 0) begin
                        // Subtraction successful: update remainder and set quotient bit to 1
                        SR <= {remainder_sub[7:0], SR[7:0], 1'b1}; 
                        // Shift left by 1: 
                        // - upper 8 bits remainder updated to remainder_sub[7:0]
                        // - shift quotient left by 1, LSB set to 1
                        // But we appended quotient bits at LSB, so shift must be carefully done:

                        // Actually we do a combined shift left by 1:
                        // Before shift: SR = [remainder(8 bits)] [quotient(8 bits)]
                        // After shift left by 1:
                        //   new remainder = (remainder_sub << 1) & 8 bits plus bit shifted in from quotient MSB
                        //   new quotient = (quotient << 1) + 1

                        // To simplify:
                        // We'll implement shift left by 1 on SR, then overwrite remainder with remainder_sub.
                        // But that is complicated, so here is a better approach:

                        // So just do shift left by 1 on SR, then if subtraction success,
                        // replace remainder bits with remainder_sub.

                        // We'll update SR in combinational block later for correctness.
                    end else begin
                        // Subtraction failed: keep remainder same (shifted), set quotient bit to 0
                        // Similarly, shift left by 1, quotient bit 0
                    end
                end

                COMPLETE: begin
                    // Output final result with sign correction
                    res_valid <= 1'b1;

                    // Apply sign corrections here in separate combinational always or in next always block

                end
            endcase

            if(state == IDLE && opn_valid && !res_valid) begin
                cnt <= 4'd0;
                // Initialize SR and sign flags done above
            end

            if(state == RUN) begin
                // Shift left SR by 1 bit
                // Insert quotient bit at LSB depending on subtraction success

                if (remainder_sub >= 0) begin
                    // Shift left by 1 and insert 1 at LSB
                    // Update remainder part with remainder_sub
                    // remainder_sub is 9 bits, use bits [7:0] as new remainder

                    // Shift left by 1:
                    // SR before shift: [15:8] remainder, [7:0] quotient
                    // Combine them as 16 bits, shift left by 1
                    // Then set remainder bits to remainder_sub[7:0]

                    // Perform shift
                    SR <= {remainder_sub[7:0], SR[7:0], 1'b1} >> 1 << 1; // This looks complicated

                    // Instead do the operation combinationally below
                end else begin
                    // Shift left by 1 and insert 0 at LSB, remainder unchanged (except shifted left)

                    // Similarly will do combinationally below
                end
            end
        end
    end

    // To simplify the update of SR during RUN state, we use combinational logic:
    reg [15:0] SR_next;
    always @(*) begin
        if(state == RUN) begin
            if(remainder_sub >= 0) begin
                // Subtraction success:
                // Shift SR left by 1, LSB set to 1
                SR_next = {SR[14:0], 1'b1};
                // Overwrite remainder bits (upper 8 bits) with remainder_sub[7:0]
                SR_next[15:8] = remainder_sub[7:0];
            end else begin
                // Subtraction fail:
                // Shift SR left by 1, LSB set to 0
                SR_next = {SR[14:0], 1'b0};
                // remainder bits already shifted, no update of remainder needed
            end
        end else begin
            SR_next = SR;
        end
    end

    // Assign SR update
    always @(posedge clk) begin
        if(state == RUN) begin
            SR <= SR_next;
        end
    end

    // Sign correction for quotient and remainder in COMPLETE state
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;
    reg [7:0] quotient_corr;
    reg [7:0] remainder_corr;

    always @(*) begin
        // Extract quotient and remainder raw
        quotient_raw = SR[7:0];
        remainder_raw = SR[15:8];

        // Quotient sign correction
        if(quotient_neg)
            quotient_corr = (~quotient_raw) + 8'd1;
        else
            quotient_corr = quotient_raw;

        // Remainder sign correction
        if(remainder_neg)
            remainder_corr = (~remainder_raw) + 8'd1;
        else
            remainder_corr = remainder_raw;
    end

    // Update result register in COMPLETE state
    always @(posedge clk) begin
        if(state == COMPLETE) begin
            result <= {remainder_corr, quotient_corr};
        end
    end

endmodule