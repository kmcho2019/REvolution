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

    reg [16:0] SR;           // shift register: remainder(9 bits) + quotient(8 bits)
    reg [8:0]  neg_divisor;  // negative divisor extended to 9 bits
    reg [3:0]  cnt;          // 4-bit counter from 0 to 8
    reg        running;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       dividend_neg;
    reg       divisor_neg;
    reg       quotient_neg;
    reg       remainder_neg;

    reg [7:0] quotient;
    reg [7:0] remainder;

    // Function to get absolute value for signed inputs
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = (sign && val[7]) ? (~val + 1'b1) : val;
        end
    endfunction

    wire [8:0] sub_res;
    wire       sub_carry;

    assign {sub_carry, sub_res} = {1'b0, SR[16:8]} + neg_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'd0;
            neg_divisor  <= 9'd0;
            cnt          <= 4'd0;
            running      <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            quotient     <= 8'd0;
            remainder    <= 8'd0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid && divisor != 0) begin
                    // Capture absolute values and signs
                    dividend_abs  <= abs8(dividend);
                    divisor_abs   <= abs8(divisor);
                    dividend_neg  <= sign ? dividend[7] : 1'b0;
                    divisor_neg   <= sign ? divisor[7] : 1'b0;
                    quotient_neg  <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                    remainder_neg <= sign ? dividend[7] : 1'b0;

                    // Initialize SR with dividend_abs shifted left by 1 bit (LSB=0)
                    SR <= {dividend_abs, 1'b0};
                    // Negative divisor for subtraction: -divisor_abs extended to 9 bits
                    neg_divisor <= (~{1'b0, abs8(divisor)} + 1'b1);
                    cnt <= 4'd0;
                    running <= 1'b1;
                end
            end else begin
                // Division steps
                if (cnt < 8) begin
                    if (sub_carry) begin
                        // subtraction succeeded, update remainder and set quotient bit = 1
                        SR <= {sub_res[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction failed, shift left quotient bit = 0
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Division done
                    quotient  <= SR[8:1];
                    remainder <= SR[16:9];

                    // Adjust sign if signed operation
                    if (sign) begin
                        if (quotient_neg)
                            quotient  <= (~quotient) + 1'b1;
                        if (remainder_neg)
                            remainder <= (~remainder) + 1'b1;
                    end

                    result    <= {remainder, quotient};
                    res_valid <= 1'b1;
                    running   <= 1'b0;
                end
            end

            // Clear res_valid if new operation requested while result is valid
            if (res_valid && opn_valid && !running) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule