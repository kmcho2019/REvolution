module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result  // [15:8] = remainder, [7:0] = quotient
);

    reg [3:0] cnt;
    reg start_cnt;

    reg quotient_sign;
    reg remainder_sign;

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // Shift register holds partial remainder (9 bits) and quotient (8 bits)
    reg [16:0] SR;

    // Subtraction result and carry-out used in iteration
    wire signed [8:0] partial_rem = SR[16:8];
    wire signed [8:0] trial_sub;

    // Perform trial subtraction: partial remainder - divisor (both positive)
    assign trial_sub = partial_rem - {1'b0, abs_divisor};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt           <= 4'd0;
            start_cnt     <= 1'b0;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
            abs_dividend  <= 8'd0;
            abs_divisor   <= 8'd0;
            SR            <= 17'd0;
        end else begin
            if (!start_cnt) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Compute sign flags for quotient and remainder
                    quotient_sign  <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];

                    // Compute absolute values of dividend and divisor
                    abs_dividend <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                    abs_divisor  <= (sign && divisor[7])  ? (~divisor + 1)  : divisor;

                    // Initialize shift register SR with dividend abs shifted left by 1 bit and quotient = 0
                    // SR = {partial_remainder[8:0], quotient[7:0]}
                    // partial remainder is dividend shifted left by 1, adding 0 as LSB
                    SR <= {abs_dividend, 1'b0, 8'd0};

                    cnt       <= 4'd1;
                    start_cnt <= 1'b1;
                end
            end else begin
                // Division iteration
                if (cnt[3]) begin
                    // cnt[3] == 1 means cnt reached 8 (done)
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;
                    res_valid <= 1'b1;

                    // Final quotient and remainder extraction
                    // Quotient = SR[7:0]
                    // Remainder = SR[16:9] (top 8 bits of partial remainder after last iteration)
                    // Adjust signs if signed operation
                    if (quotient_sign)
                        result[7:0] <= (~SR[7:0]) + 1'b1;
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_sign)
                        result[15:8] <= (~SR[16:9]) + 1'b1;
                    else
                        result[15:8] <= SR[16:9];
                end else begin
                    // Continue division iteration
                    if (trial_sub[8] == 1'b0) begin
                        // trial_sub >= 0: subtraction successful, shift in '1' quotient bit
                        // Update partial remainder and quotient bits:
                        // Shift left SR by 1 bit and put '1' in LSB of quotient
                        SR <= {trial_sub[7:0], SR[7:0], 1'b1};
                    end else begin
                        // trial_sub < 0: restore partial remainder, shift in '0' quotient bit
                        // Shift left SR by 1 bit and put '0' in LSB quotient
                        SR <= {partial_rem[7:0], SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule