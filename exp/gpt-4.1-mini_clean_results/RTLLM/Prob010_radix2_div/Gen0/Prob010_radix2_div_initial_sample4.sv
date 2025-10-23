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

    reg [8:0] SR;                // shift register: 9 bits to hold remainder and quotient bits during operation
    reg [7:0] NEG_DIVISOR;       // negated absolute divisor for subtraction
    reg [3:0] cnt;               // 4 bits counter, count 1 to 8
    reg       start_cnt;         // start flag
    reg [7:0] ABS_DIVIDEND;
    reg [7:0] ABS_DIVISOR;
    reg       DIVIDEND_NEG;      // sign bit of dividend
    reg       DIVISOR_NEG;       // sign bit of divisor

    // Internal wires for subtraction
    wire [8:0] sub_res;
    wire       sub_cout;         // carry out from subtraction (indicates if subtraction result is >= 0)

    // 2's complement negation
    wire [7:0] dividend_signed = dividend;
    wire [7:0] divisor_signed  = divisor;

    // Calculate absolute values and signs on start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            DIVIDEND_NEG <= 0;
            DIVISOR_NEG  <= 0;
            ABS_DIVIDEND <= 0;
            ABS_DIVISOR  <= 0;
        end else if (opn_valid && !res_valid) begin
            if (sign) begin
                DIVIDEND_NEG <= dividend[7];
                DIVISOR_NEG  <= divisor[7];
                ABS_DIVIDEND <= dividend[7] ? (~dividend + 1'b1) : dividend;
                ABS_DIVISOR  <= divisor[7]  ? (~divisor + 1'b1)  : divisor;
            end else begin
                DIVIDEND_NEG <= 0;
                DIVISOR_NEG  <= 0;
                ABS_DIVIDEND <= dividend;
                ABS_DIVISOR  <= divisor;
            end
        end
    end

    // NEG_DIVISOR is negated absolute divisor, 8 bits with 2's complement
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NEG_DIVISOR <= 0;
        end else if (opn_valid && !res_valid) begin
            NEG_DIVISOR <= ~ABS_DIVISOR + 1'b1; // 2's complement negation
        end
    end

    // Initialize SR, cnt, and start_cnt on new operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR        <= 0;
            cnt       <= 0;
            start_cnt <= 0;
        end else if (opn_valid && !res_valid) begin
            // SR initialized as {ABS_DIVIDEND,1'b0}
            // 9 bits = ABS_DIVIDEND shifted left by 1 bit
            SR        <= {ABS_DIVIDEND, 1'b0};
            cnt       <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            // division iterations
            if (cnt[3]) begin
                // cnt == 8 (MSB set), division complete
                cnt       <= 0;
                start_cnt <= 0;
                // final SR contains remainder and quotient
                // handled later for sign correction
            end else begin
                cnt <= cnt + 1'b1;
                // calculate subtraction and update SR
                // sub_res = SR[8:1] + NEG_DIVISOR
                // because division step: remainder - divisor (NEG_DIVISOR is -divisor)
                // SR[8:1] is current remainder (8 bits)
                // subtraction is SR[8:1] + NEG_DIVISOR (9 bits operation)
                // but NEG_DIVISOR is 8 bits, so extend to 9 bits with sign extension
                // We'll extend NEG_DIVISOR to 9 bits by sign extension
                // Use signed arithmetic to get subtraction
                // We'll implement subtraction logic combinationally below
                // shift SR left by 1 and insert carry out as new LSB (quotient bit)

                // This assignment to SR will be done after combinational sub_res and sub_cout calculated
                // So here we just wait for combinational logic
            end
        end else begin
            cnt <= 0;
            start_cnt <= 0;
        end
    end

    // Combinational subtraction and SR update:
    wire [8:0] remainder = SR[8:1];

    wire [8:0] NEG_DIV_EXT = {NEG_DIVISOR[7], NEG_DIVISOR}; // sign extend NEG_DIVISOR to 9 bits
    assign sub_res = remainder + NEG_DIV_EXT; // remainder - divisor = remainder + (-divisor)

    assign sub_cout = ~sub_res[8]; // sub_cout is 1 if no borrow (remainder >= divisor), so MSB=0 means no borrow

    // Update SR in next clock when start_cnt=1 and cnt < 8
    always @(posedge clk) begin
        if (start_cnt && !cnt[3]) begin
            // update SR:
            // If subtraction result >= 0 (sub_cout==1), we keep the subtraction result as new remainder and shift in 1
            // Else keep old remainder, shift in 0
            if (sub_cout) begin
                // remainder updated with sub_res[7:0], quotient bit = 1
                SR <= {sub_res[7:0], SR[0], 1'b1};
            end else begin
                // remainder unchanged, quotient bit = 0
                SR <= {SR[7:0], SR[0], 1'b0};
            end
        end
    end

    // After division complete, perform sign correction on quotient and remainder
    // The quotient is in SR[7:0], remainder is in SR[8:1]
    // result = {remainder, quotient}

    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Perform correction combinationally when division done (start_cnt==0 && cnt==0) and last op complete
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            final_quotient  <= 0;
            final_remainder <= 0;
            result          <= 0;
            res_valid       <= 0;
        end else begin
            if (!start_cnt && (cnt == 0) && (opn_valid == 0)) begin
                // Division complete, sign correction

                // Quotient sign:
                // If sign == 1 and dividend sign ^ divisor sign = 1, quotient is negative, else positive
                // remainder sign is sign of dividend

                // quotient correction: if negative, 2's complement it
                if (sign && (DIVIDEND_NEG ^ DIVISOR_NEG)) begin
                    final_quotient <= ~SR[7:0] + 1'b1;
                end else begin
                    final_quotient <= SR[7:0];
                end

                // remainder correction: if dividend negative, remainder = -remainder
                if (sign && DIVIDEND_NEG) begin
                    final_remainder <= ~SR[8:1] + 1'b1;
                end else begin
                    final_remainder <= SR[8:1];
                end

                result <= {final_remainder, final_quotient};
                res_valid <= 1'b1;
            end else if (opn_valid && !res_valid) begin
                // new operation started, clear res_valid
                res_valid <= 1'b0;
            end else if (res_valid && opn_valid) begin
                // If the user sends new operation while res_valid is high, clear res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule