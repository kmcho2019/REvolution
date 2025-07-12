module radix2_div (
    input          clk,
    input          rst,
    input          sign,           // 1: signed division, 0: unsigned
    input   [7:0]  dividend,
    input   [7:0]  divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result        // {remainder[7:0], quotient[7:0]}
);

    reg [15:0] SR;       // shift register: {remainder[8:0], quotient[7:0]}, use 17 bits but SR[16] unused for clarity
    reg [8:0]  neg_divisor;
    reg [3:0]  cnt;
    reg        busy;

    reg        dividend_sign;
    reg        divisor_sign;
    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    function [7:0] abs8;
        input [7:0] val;
        input       s;  // sign enable
        begin
            abs8 = (s && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 16'd0;
            neg_divisor  <= 9'd0;
            cnt          <= 4'd0;
            busy         <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
        end else begin
            if (!busy) begin
                if (opn_valid && !res_valid && divisor != 8'd0) begin
                    dividend_sign <= sign && dividend[7];
                    divisor_sign  <= sign && divisor[7];
                    dividend_abs  <= abs8(dividend, sign);
                    divisor_abs   <= abs8(divisor, sign);

                    // Negative divisor for subtraction: two's complement 9-bit
                    neg_divisor <= {1'b1, ~divisor_abs} + 9'd1;
                    // Initialize shift register: remainder (9 bits) = dividend_abs shifted left 1,
                    // quotient (8 bits) = 0
                    SR <= {dividend_abs, 8'd0} << 1;  
                    cnt <= 4'd1;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Perform one radix-2 division iteration
                // Current remainder in SR[16:8], quotient in SR[7:0]
                // Note: SR is 16 bits: SR[15:8] is remainder upper bits, we use 9 bits remainder internally, so keep remainder 9-bit in SR[16:8],
                // but since SR is 16 bits, use SR[15:8] as remainder[7:0] and track borrow with separate carry out.
                // We extend remainder with 1 bit borrowed outside for subtraction.
                // So implement subtraction using a 9-bit adder: remainder + neg_divisor
                // Let rem = SR[15:7], but for 9-bit, construct remainder as {1'b0, SR[15:8]}
                // For clarity, make a 9-bit remainder register:
                // We implement subtract with borrow (carry out inverted)

                reg [8:0] remainder;
                reg [8:0] sub_res;
                reg       borrow;

                remainder = {1'b0, SR[15:8]};
                sub_res = remainder + neg_divisor;
                borrow = sub_res[8]; // If MSB=1 means no borrow (subtraction succeeded)

                if (borrow) begin
                    // subtraction successful, update remainder = sub_res[7:0]
                    SR[15:8] <= sub_res[7:0];
                    // Shift left quotient and insert 1
                    SR = {SR[14:0], 1'b1};
                end else begin
                    // subtraction failed, restore remainder, quotient bit = 0
                    SR = {SR[14:0], 1'b0};
                end

                if (cnt == 4'd8) begin
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder
                    // remainder = SR[15:8]
                    // quotient = SR[7:0]

                    reg [7:0] quotient;
                    reg [7:0] remainder8;

                    quotient = SR[7:0];
                    remainder8 = SR[15:8];

                    // Apply sign correction
                    if (sign) begin
                        if (dividend_sign ^ divisor_sign)
                            quotient = ~quotient + 8'd1; // negate quotient
                        if (dividend_sign)
                            remainder8 = ~remainder8 + 8'd1; // negate remainder
                    end

                    result <= {remainder8, quotient};
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end

            // Clear result valid if new operation starts without busy
            if (res_valid && opn_valid && !busy)
                res_valid <= 1'b0;
        end
    end
endmodule