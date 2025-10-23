module radix2_div(
    input           clk,
    input           rst,
    input           sign,           // 1: signed division, 0: unsigned
    input  [7:0]    dividend,
    input  [7:0]    divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       sign_quotient, sign_remainder;
    reg [3:0] cnt;
    reg start_div;
    
    wire [7:0] dividend_abs = (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
    wire [7:0] divisor_abs  = (sign && divisor_reg[7])  ? (~divisor_reg  + 1) : divisor_reg;

    // 17-bit shift register: [16:8] remainder(9 bits), [7:0] quotient
    reg [16:0] SR;

    wire [8:0] remainder = SR[16:8];
    wire [8:0] sub = remainder - {1'b0, divisor_abs};
    wire       sub_borrow = sub[8];          // borrow if MSB is 1
    wire       quotient_bit = ~sub_borrow;

    wire [16:0] SR_next = {quotient_bit ? sub[8:0] : remainder, SR[7:1], quotient_bit};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_reg  <= 8'd0;
            divisor_reg   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder<= 1'b0;
            SR            <= 17'd0;
            cnt           <= 4'd0;
            start_div     <= 1'b0;
        end else begin
            if (opn_valid && !start_div && !res_valid) begin
                // Capture inputs and signs
                dividend_reg  <= dividend;
                divisor_reg   <= divisor;
                if (sign) begin
                    dividend_neg  <= dividend[7];
                    divisor_neg   <= divisor[7];
                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder<= dividend[7];
                end else begin
                    dividend_neg  <= 1'b0;
                    divisor_neg   <= 1'b0;
                    sign_quotient <= 1'b0;
                    sign_remainder<= 1'b0;
                end
                // Initialize shift register with dividend_abs in remainder, quotient=0
                // remainder is 9 bits: upper zero bit + 8 bits dividend_abs
                SR <= {1'b0, dividend_abs, 8'b0};
                cnt <= 4'd0;
                start_div <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_div) begin
                // Perform iterative division steps
                SR <= SR_next;
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    start_div <= 1'b0;
                    // Apply sign corrections after division done
                    // Extract raw quotient and remainder
                    reg [7:0] quotient_u;
                    reg [7:0] remainder_u;
                    reg [7:0] quotient_s;
                    reg [7:0] remainder_s;

                    quotient_u = SR_next[7:0];
                    remainder_u = SR_next[16:9];

                    quotient_s = sign_quotient ? (~quotient_u + 1) : quotient_u;
                    remainder_s = sign_remainder ? (~remainder_u + 1) : remainder_u;

                    result <= {remainder_s, quotient_s};
                    res_valid <= 1'b1;
                end
            end else begin
                // When result valid, keep it until new opn_valid starts division
                if (res_valid && opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule