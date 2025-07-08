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

// Internal signals and registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;

reg start_cnt;
reg [3:0] cnt; // 4 bits to count up to 8

// Shift register SR: 9 bits (remainder+quotient shifted left by 1)
reg [8:0] SR;

// NEG_DIVISOR for subtraction, 9 bits to align with SR
reg [8:0] NEG_DIVISOR;

// Flags and temp variables
reg dividend_neg;
reg divisor_neg;

wire [8:0] abs_dividend;
wire [8:0] abs_divisor;
wire [8:0] sub_result;
wire sub_carry_out;
wire [8:0] SR_shifted_in;

// Absolute value computation for dividend
wire [7:0] dividend_abs;
assign dividend_abs = (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
// Absolute value computation for divisor
wire [7:0] divisor_abs;
assign divisor_abs = (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

// Prepare 9-bit abs values aligned to SR width (one more bit for sign/overflow safety)
assign abs_dividend = {1'b0, dividend_abs};
assign abs_divisor  = {1'b0, divisor_abs};

// Subtraction: SR - NEG_DIVISOR = SR + divisor (since NEG_DIVISOR = -divisor)
// But NEG_DIVISOR is negative of divisor_abs (signed 9 bits), so to subtract divisor,
// we do SR + NEG_DIVISOR (NEG_DIVISOR is negative divisor_abs)
wire [9:0] sub_full;
assign sub_full = {1'b0, SR} + NEG_DIVISOR; // 10 bits to catch carry out

assign sub_result = sub_full[8:0];
assign sub_carry_out = sub_full[9]; // carry out bit

// On reset or operation start
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        result <= 0;
    end else begin
        // Start operation when opn_valid high and res_valid low
        if (opn_valid && !res_valid) begin
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            // Compute signs
            dividend_neg <= sign && dividend[7];
            divisor_neg <= sign && divisor[7];
            // Initialize SR with abs(dividend) shifted left by 1 bit
            SR <= {abs_dividend, 1'b0}; // 9 bits
            // NEG_DIVISOR = -abs(divisor), 9 bits signed
            // abs_divisor is positive, negate by two's complement
            NEG_DIVISOR <= (~{1'b0, divisor_abs} + 1'b1);
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end else if (start_cnt) begin
            // If division in progress
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                cnt <= 0;

                // Final remainder = upper 8 bits of SR (bits 8:1)
                // Final quotient = lower 8 bits of SR (bits 7:0)
                // Adjust signs for signed division:

                // Extract remainder and quotient before sign correction
                reg [7:0] remainder_unsigned;
                reg [7:0] quotient_unsigned;
                reg remainder_neg_final;
                reg quotient_neg_final;
                reg [7:0] remainder_final;
                reg [7:0] quotient_final;

                remainder_unsigned = SR[8:1];
                quotient_unsigned = SR[7:0];

                // Compute final signs
                remainder_neg_final = dividend_neg;
                quotient_neg_final = dividend_neg ^ divisor_neg;

                // Convert quotient to signed if negative
                if (sign && quotient_neg_final)
                    quotient_final = (~quotient_unsigned + 1'b1);
                else
                    quotient_final = quotient_unsigned;

                // Convert remainder to signed if negative
                if (sign && remainder_neg_final)
                    remainder_final = (~remainder_unsigned + 1'b1);
                else
                    remainder_final = remainder_unsigned;

                // Pack result: remainder upper 8 bits, quotient lower 8 bits
                result <= {remainder_final, quotient_final};
                res_valid <= 1;
            end else begin
                // Division iteration step

                // Try subtracting divisor: SR + NEG_DIVISOR
                if (sub_carry_out) begin
                    // subtraction successful (no borrow)
                    // Shift left SR, insert 1 at LSB (quotient bit)
                    SR <= {sub_result[7:0], 1'b1};
                end else begin
                    // subtraction failed (borrow), restore SR and shift left insert 0
                    SR <= {SR[7:0], 1'b0};
                end

                cnt <= cnt + 1;
            end
        end else if (res_valid) begin
            // Result valid, wait for next operation
            if (opn_valid) begin
                // Consume result and start new operation next cycle
                res_valid <= 0;
            end
        end
    end
end

endmodule