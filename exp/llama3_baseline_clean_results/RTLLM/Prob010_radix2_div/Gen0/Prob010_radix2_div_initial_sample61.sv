module radix2_div(
    input clk, rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [7:0] sr; // Shift Register
reg [2:0] cnt; // Counter
reg start_cnt;
reg [15:0] result_reg; // Register to hold the final result
reg [7:0] remainder; // Remainder of the division
reg [7:0] quotient; // Quotient of the division
reg carry_out; // Carry out from subtraction

// Abs function for signed numbers
function [7:0] abs(input [7:0] a);
    if (a[7] == 1'b1)
        abs = ~a + 1;
    else
        abs = a;
endfunction

// Subtraction with borrow
always @(*)
begin
    if (sr >= neg_divisor)
    begin
        carry_out = 1'b1;
        remainder = sr - neg_divisor;
    end
    else
    begin
        carry_out = 1'b0;
        remainder = sr;
    end
end

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        neg_divisor <= 8'b0;
        sr <= 9'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        result_reg <= 16'b0;
        remainder <= 8'b0;
        quotient <= 8'b0;
    end
    else if (opn_valid && !res_valid)
    begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // Initialize registers
        if (sign)
        begin
            if (dividend[7] == 1'b1)
                sr <= {1'b0, abs(dividend_reg)} << 1;
            else
                sr <= {1'b0, dividend_reg} << 1;
        end
        else
            sr <= {1'b0, dividend_reg} << 1;
        
        if (divisor[7] == 1'b1)
            neg_divisor <= ~(abs(divisor_reg)) + 1;
        else
            neg_divisor <= ~(divisor_reg);
        
        cnt <= 1;
        start_cnt <= 1'b1;
        res_valid <= 1'b0;
    end
    else if (start_cnt)
    begin
        if (cnt == 8)
        begin
            // Division complete, update result
            if (sign && (dividend_reg[7] ^ divisor_reg[7]))
                quotient <= ~sr[7:0] + 1;
            else
                quotient <= sr[7:0];
            remainder <= sr[15:8];
            result_reg <= {remainder, quotient};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 3'b0;
        end
        else
        begin
            // Update SR and cnt
            if (carry_out)
                sr <= {remainder, 1'b1} << 1;
            else
                sr <= {remainder, 1'b0} << 1;
            cnt <= cnt + 1;
        end
    end
    else if (res_valid && !opn_valid)
    begin
        // Reset result validity when result is consumed
        res_valid <= 1'b0;
    end
end

assign result = result_reg;

endmodule