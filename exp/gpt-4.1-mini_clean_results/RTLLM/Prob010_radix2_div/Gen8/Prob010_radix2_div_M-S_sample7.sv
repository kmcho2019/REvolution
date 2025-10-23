module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // Internal signals and registers
    reg [16:0] SR;           // Shift register: {remainder[8:0], quotient[7:0]}
    reg [7:0]  divisor_abs;
    reg [8:0]  neg_divisor;  // 9-bit negated divisor for subtraction
    reg [3:0]  cnt;
    reg        start_cnt;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    wire [8:0] remainder = SR[16:8];
    wire [7:0] quotient  = SR[7:0];

    // Functions for abs and negate 8-bit values
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 8'd1;
            else
                abs8 = val;
        end
    endfunction

    function [8:0] negate9;
        input [8:0] val;
        begin
            negate9 = (~val) + 9'd1;
        end
    endfunction

    // Combinational subtraction remainder - divisor_abs
    wire [9:0] sub_res = {1'b0, remainder} + {1'b0, neg_divisor}; // remainder - divisor_abs
    wire       sub_res_nonneg = ~sub_res[9]; // if highest bit 0, sub_res >=0

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 17'd0;
            divisor_abs <= 8'd0;
            neg_divisor <= 9'd0;
            cnt         <= 4'd0;
            start_cnt   <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;

            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Capture abs values
                divisor_abs <= abs8(divisor);
                neg_divisor <= negate9({1'b0, abs8(divisor)}); // 9-bit negated divisor

                dividend_neg <= (sign && dividend[7]);
                divisor_neg  <= (sign && divisor[7]);
                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg<= (sign && dividend[7]);

                // Initialize SR: remainder=0, quotient=abs(dividend)
                SR <= {9'd0, abs8(dividend)};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (start_cnt) begin
                // One division iteration per clock
                // Shift left SR by 1
                SR <= {SR[15:0], 1'b0};

                // Subtract divisor_abs from remainder (upper 9 bits after shift)
                if (sub_res_nonneg) begin
                    // If subtraction >= 0, update remainder = sub_res and set quotient LSB to 1
                    SR[16:8] <= sub_res[8:0];
                    SR[0] <= 1'b1;
                end else begin
                    // If subtraction < 0, restore remainder and quotient LSB = 0 (already zero by shift)
                    // Do nothing (remainder stays after shift)
                end

                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // Sign correction
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Quotient correction
                    if (quotient_neg)
                        final_quotient = (~SR[7:0]) + 8'd1;
                    else
                        final_quotient = SR[7:0];

                    // Remainder correction
                    if (remainder_neg)
                        final_remainder = (~SR[16:9]) + 8'd1;
                    else
                        final_remainder = SR[16:9];

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end else begin
                // Wait for res_ready to clear res_valid if needed (not specified in problem, so keep res_valid until next op)
                // Simply keep res_valid until next opn_valid
                if (res_valid && opn_valid) begin
                    res_valid <= 1'b0; // Clear result valid on new operation start
                end
            end
        end
    end

endmodule