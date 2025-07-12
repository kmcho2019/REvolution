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

    // Shift register SR holds remainder and quotient during division
    // Width 17 bits: SR[16:9] remainder (8 bits + 1 extra bit for borrow detection), SR[8:0] quotient (9 bits)
    reg [16:0] SR;

    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;

    reg [3:0] cnt;        // counts 0..8 cycles
    reg start;            // division process active

    reg dividend_sign;
    reg divisor_sign;

    // Intermediate combinational signals for subtraction and borrow detection
    wire [8:0] remainder_ext;  // 9-bit extended remainder for subtraction (MSB = borrow bit)
    wire [8:0] divisor_ext;   // divisor extended to 9 bits
    wire [8:0] sub;           // subtraction result (remainder_ext - divisor_ext)
    wire borrow;              // borrow indicator (if MSB of sub is 1)

    // Next state of SR (combinationally derived from current SR and subtraction result)
    reg [16:0] SR_next;

    // Compute absolute value function
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 1) : val;
        end
    endfunction

    // Two's complement negation function
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 1;
        end
    endfunction

    // Assign extended signals combinationally outside always block
    assign remainder_ext = SR[16:8];       // upper 9 bits of SR: remainder plus borrow bit
    assign divisor_ext   = {1'b0, divisor_abs}; // divisor extended to 9 bits
    assign sub           = remainder_ext - divisor_ext;
    assign borrow        = sub[8];

    // Combinational logic to compute SR_next based on subtraction result
    always @(*) begin
        if (!borrow) begin
            // subtraction succeeded, update remainder to sub[7:0], shift quotient left and set LSB=1
            SR_next[16:9] = sub[7:0];         // new remainder
            SR_next[8:1]  = SR[7:0];          // quotient shifted left by 1 bit
            SR_next[0]    = 1'b1;              // quotient LSB set to 1
        end else begin
            // subtraction failed, keep remainder, shift quotient left and set LSB=0
            SR_next[16:9] = SR[16:9];         // old remainder unchanged
            SR_next[8:1]  = SR[7:0];          // quotient shifted left by 1 bit
            SR_next[0]    = 1'b0;              // quotient LSB set to 0
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            res_valid      <= 1'b0;
            start          <= 1'b0;
            cnt            <= 4'd0;
            SR             <= 17'd0;
            divisor_abs    <= 8'd0;
            dividend_abs   <= 8'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            result         <= 16'd0;
        end else begin
            if (!start) begin
                // idle state - wait for opn_valid and res_valid low to start new division
                res_valid <= 1'b0;

                if (opn_valid) begin
                    // latch input signs if signed operation
                    if (sign) begin
                        dividend_sign <= dividend[7];
                        divisor_sign  <= divisor[7];
                        dividend_abs  <= abs8(dividend);
                        divisor_abs   <= abs8(divisor);
                    end else begin
                        dividend_sign <= 1'b0;
                        divisor_sign  <= 1'b0;
                        dividend_abs  <= dividend;
                        divisor_abs   <= divisor;
                    end

                    if (divisor == 8'd0) begin
                        // division by zero: output maximum quotient (all 1's) and dividend as remainder immediately
                        res_valid <= 1'b1;
                        result <= {dividend, 8'hFF};
                        start <= 1'b0;
                        cnt <= 4'd0;
                        SR <= 17'd0;
                    end else begin
                        // Initialize SR: remainder = 0, quotient = dividend_abs, shift left by 1
                        SR <= ({9'd0, dividend_abs} << 1);
                        cnt <= 4'd0;
                        start <= 1'b1;
                        res_valid <= 1'b0;
                    end
                end
            end else begin
                // division process running
                // Update SR with next value computed combinationally
                SR <= SR_next;

                cnt <= cnt + 4'd1;

                if (cnt == 4'd7) begin
                    // After 8 cycles (cnt counts from 0 to 7), division done
                    start <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder
                    // quotient: SR_next[8:1] (8 bits)
                    // remainder: SR_next[16:9] (8 bits)
                    // Sign correction if signed operation

                    reg [7:0] quotient_val;
                    reg [7:0] remainder_val;

                    quotient_val = SR_next[8:1];
                    remainder_val = SR_next[16:9];

                    if (sign) begin
                        // quotient sign = dividend_sign XOR divisor_sign
                        if (dividend_sign ^ divisor_sign)
                            quotient_val = neg8(quotient_val);
                        // remainder sign = dividend_sign
                        if (dividend_sign)
                            remainder_val = neg8(remainder_val);
                    end

                    result <= {remainder_val, quotient_val};
                end
            end
        end
    end

endmodule