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

    reg [16:0] SR;           // [16:9] remainder bits (9 bits), [8:1] quotient bits, [0] unused in shift
    reg [3:0]  cnt;
    reg        busy;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       quotient_neg;
    reg       remainder_neg;

    // Compute absolute value if signed
    function [7:0] abs_val;
        input [7:0] val;
        begin
            abs_val = (sign && val[7]) ? (~val + 1) : val;
        end
    endfunction

    // Two's complement negation
    function [7:0] neg_val;
        input [7:0] val;
        begin
            neg_val = ~val + 1;
        end
    endfunction

    wire [8:0] remainder = SR[16:8];
    wire [8:0] sub = remainder - {1'b0, divisor_abs};
    wire       borrow = sub[8];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 17'd0;
            cnt         <= 4'd0;
            busy        <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            quotient_neg<= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    dividend_abs <= abs_val(dividend);
                    divisor_abs  <= abs_val(divisor);
                    quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                    remainder_neg<= sign && dividend[7];
                    // Initialize SR: remainder = dividend_abs (9 bits with leading zero), quotient = 0
                    SR <= {9'd0, dividend_abs, 1'b0}; // shift dividend_abs left by 1 to fit 9 bits remainder part
                    cnt <= 0;
                    busy <= 1'b1;
                end
            end else begin
                if (divisor_abs == 0) begin
                    // Divisor zero: produce zero result immediately
                    cnt <= 8;
                    SR <= 17'd0;
                end else if (cnt < 8) begin
                    if (!borrow) begin
                        // subtraction non-negative: update remainder with sub result, shift in quotient bit 1
                        SR <= {sub[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative: keep remainder, shift in quotient bit 0
                        SR <= {remainder[7:0], SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
                if (cnt == 8) begin
                    // Apply sign correction to quotient and remainder
                    reg [7:0] q, r;
                    q = SR[7:0];
                    r = SR[16:9]; // upper 8 bits remainder
                    if (sign) begin
                        if (quotient_neg) q = neg_val(q);
                        if (remainder_neg) r = neg_val(r);
                    end
                    result <= {r, q};
                    res_valid <= 1'b1;
                    busy <= 1'b0;
                end
            end
        end
    end

endmodule