module radix2_div (
    input           clk,
    input           rst,
    input           sign,       // 1: signed, 0: unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result     // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [8:0] SR;          // 9-bit shift register (to hold remainder & quotient bits and one extra bit)
    reg [7:0] ABS_DIVIDEND;
    reg [7:0] ABS_DIVISOR;
    reg [7:0] NEG_DIVISOR; // Two's complement negated divisor (absolute)
    reg [3:0] cnt;         // counts from 1 to 8 for the 8 division cycles
    reg       start_cnt;   // control signal to start count/process
    reg       dividend_sign;  // sign bit of dividend
    reg       divisor_sign;   // sign bit of divisor

    // Internal wires for subtraction result
    wire [8:0] sub_res;   // 9-bit subtraction result: SR[8:1] + NEG_DIVISOR
    wire       sub_carry; // carry out from subtraction indicating whether subtraction result is >= 0

    // Sign management
    wire quotient_sign;
    wire remainder_sign;
    wire [7:0] quotient_raw;
    wire [7:0] remainder_raw;

    // Compute subtraction: SR[8:1] - ABS_DIVISOR
    // NEG_DIVISOR = two's complement of ABS_DIVISOR
    assign sub_res = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR}; 
    // If MSB of sub_res is 1, subtraction result is negative and carry out is 0,
    // if MSB is 0, subtraction result is positive or zero and carry out is 1
    assign sub_carry = ~sub_res[8]; // carry = 1 if no borrow (= subtraction >= 0)

    // Raw quotient and remainder extraction from SR after process
    assign quotient_raw = SR[7:0];
    assign remainder_raw = SR[8:1];

    // Determine quotient and remainder sign
    // Quotient sign = dividend_sign ^ divisor_sign if signed operation
    // Remainder sign = dividend_sign if signed operation
    assign quotient_sign = sign & (dividend_sign ^ divisor_sign);
    assign remainder_sign = sign & dividend_sign;

    // Functions to get absolute value
    function [7:0] abs8;
        input [7:0] val;
        input       sign_bit;
        begin
            if(sign_bit) abs8 = (~val) + 8'b1;
            else         abs8 = val;
        end
    endfunction

    // Functions to get signed value from abs and sign bit
    function [7:0] to_signed8;
        input [7:0] val;
        input       sign_bit;
        begin
            if(sign_bit) to_signed8 = (~val) + 8'b1;
            else         to_signed8 = val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            SR <= 9'd0;
            ABS_DIVIDEND <= 8'd0;
            ABS_DIVISOR <= 8'd0;
            NEG_DIVISOR <= 8'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if(opn_valid && !res_valid) begin
                // Capture inputs and initialize
                dividend_sign <= sign & dividend[7];
                divisor_sign <= sign & divisor[7];

                // Compute absolute values
                ABS_DIVIDEND <= abs8(dividend, sign & dividend[7]);
                ABS_DIVISOR  <= abs8(divisor, sign & divisor[7]);

                // NEG_DIVISOR = two's complement of ABS_DIVISOR
                NEG_DIVISOR <= (~abs8(divisor, sign & divisor[7])) + 8'b1;

                // Initialize shift register SR: dividend shifted left 1 bit
                // SR[8:1] = dividend_abs, SR[0]=0
                SR <= {abs8(dividend, sign & dividend[7]),1'b0};

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if(start_cnt) begin
                // Division process
                if(cnt == 4'd8) begin
                    // Last step complete, finalize results
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // The remainder is in SR[8:1]
                    // The quotient is in SR[7:0]

                    // Adjust signs of quotient and remainder according to inputs
                    // Quotient = if quotient_sign then negate else same
                    // Remainder = if remainder_sign then negate else same
                    result[7:0] <= quotient_sign ? to_signed8(quotient_raw,1'b1) : quotient_raw;
                    result[15:8] <= remainder_sign ? to_signed8(remainder_raw,1'b1) : remainder_raw;

                    res_valid <= 1'b1;

                end else begin
                    // Perform subtraction: SR[8:1] - divisor
                    if(sub_carry) begin
                        // subtraction succeeded, set quotient bit 1
                        // Shift left SR and insert 1 at LSB
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // subtraction failed, quotient bit = 0
                        // Shift left SR and insert 0 at LSB
                        SR <= {SR[7:0],1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end else if(res_valid && !opn_valid) begin
                // Result consumed, clear valid flag
                res_valid <= 1'b0;
            end
        end
    end

endmodule