module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);
    reg [16:0] SR; // Shift register: upper 9 bits remainder, lower 8 bits quotient
    reg [3:0]  cnt;
    reg        working;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg        quotient_sign;
    reg        remainder_sign;

    // Absolute value function
    function [7:0] abs_val;
        input [7:0] val;
        begin
            abs_val = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Two's complement negation
    function [7:0] neg_val;
        input [7:0] val;
        begin
            neg_val = ~val + 8'd1;
        end
    endfunction

    wire [8:0] remainder = SR[16:8];
    wire [8:0] diff = remainder - {1'b0, divisor_abs};
    wire borrow = diff[8]; // borrow if diff is negative

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR         <= 17'd0;
            cnt        <= 4'd0;
            res_valid  <= 1'b0;
            result     <= 16'd0;
            working    <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
        end else begin
            if (!working) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    dividend_abs   <= abs_val(dividend);
                    divisor_abs    <= abs_val(divisor);
                    quotient_sign  <= sign && (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign && dividend[7];
                    // Initialize SR with dividend_abs shifted left 1 bit, quotient zero
                    SR <= {dividend_abs, 1'b0, 8'd0};
                    cnt <= 4'd0;
                    working <= 1'b1;
                end
            end else begin
                // If divisor_abs is zero, division undefined; output zero result immediately
                if (divisor_abs == 0) begin
                    SR <= 17'd0;
                    cnt <= 4'd8; // end immediately
                end else if (cnt < 8) begin
                    if (!borrow) begin
                        // subtraction non-negative: update remainder and set quotient bit to 1
                        SR <= {diff[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative: shift left, quotient bit 0
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
                if (cnt == 8) begin
                    // Correction sign of quotient and remainder
                    reg [7:0] q, r;
                    q = SR[7:0];
                    r = SR[16:9]; // upper 8 bits of remainder, discard lowest bit used for shifting
                    if (sign) begin
                        if (quotient_sign) q = neg_val(q);
                        if (remainder_sign) r = neg_val(r);
                    end
                    result    <= {r, q};
                    res_valid <= 1'b1;
                    working   <= 1'b0;
                end
            end
        end
    end
endmodule