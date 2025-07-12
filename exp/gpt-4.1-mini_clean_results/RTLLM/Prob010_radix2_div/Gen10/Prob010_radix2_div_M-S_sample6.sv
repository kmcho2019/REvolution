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

    reg [16:0] SR;        // [16:8]: remainder (9 bits), [7:0]: quotient (8 bits)
    reg [3:0]  cnt;
    reg        busy;
    reg        quotient_neg;
    reg        remainder_neg;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    wire [8:0] remainder = SR[16:8];
    wire [8:0] sub = remainder - {1'b0, divisor_abs};
    wire       borrow = sub[8];

    // Inline absolute value calculation
    wire [7:0] dividend_abs_in  = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_in   = (sign && divisor[7])  ? (~divisor  + 1) : divisor;

    // Inline negation
    function [7:0] negate;
        input [7:0] val;
        begin
            negate = ~val + 1;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR         <= 17'd0;
            cnt        <= 0;
            busy       <= 0;
            res_valid  <= 0;
            result     <= 16'd0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            dividend_abs <= 0;
            divisor_abs  <= 0;
        end else begin
            if (!busy) begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_abs  <= dividend_abs_in;
                    divisor_abs   <= divisor_abs_in;
                    quotient_neg  <= sign && (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign && dividend[7];
                    // Load dividend_abs shifted left by 1 into remainder (9 bits), quotient zeroed
                    SR <= {dividend_abs_in, 8'd0};
                    cnt <= 0;
                    busy <= 1;
                end
            end else begin
                if (divisor_abs == 0) begin
                    // Divisor zero, output zero immediately
                    SR <= 17'd0;
                    cnt <= 8;
                end else if (cnt < 8) begin
                    if (!borrow) begin
                        // remainder >= divisor_abs: update remainder and shift in quotient bit = 1
                        SR <= {sub[7:0], SR[7:1], 1'b1};
                    end else begin
                        // remainder < divisor_abs: keep remainder, shift in quotient bit = 0
                        SR <= {remainder[7:0], SR[7:1], 1'b0};
                    end
                    cnt <= cnt + 1;
                end

                if (cnt == 8) begin
                    // Apply sign corrections
                    reg [7:0] q = SR[7:0];
                    reg [7:0] r = SR[16:9]; // remainder upper 8 bits
                    if (sign) begin
                        if (quotient_neg) q = negate(q);
                        if (remainder_neg) r = negate(r);
                    end
                    result <= {r, q};
                    res_valid <= 1;
                    busy <= 0;
                end
            end
        end
    end

endmodule