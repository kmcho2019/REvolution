module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Internal signals
reg [8:0] SR; // Shift register to hold the remainder and quotient
reg [8:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg is_dividend_negative; // Flag indicating if the dividend is negative
reg is_divisor_negative; // Flag indicating if the divisor is negative
reg [7:0] quotient; // Quotient of the division
reg [7:0] remainder; // Remainder of the division
reg carry_out; // Carry-out from the subtraction

// Combinational logic for initialization
always @(*) begin
    if (sign) begin
        is_dividend_negative = dividend[7];
        is_divisor_negative = divisor[7];
        abs_dividend = (dividend[7]) ? (~dividend + 1) : dividend;
        abs_divisor = (divisor[7]) ? (~divisor + 1) : divisor;
    end else begin
        is_dividend_negative = 1'b0;
        is_divisor_negative = 1'b0;
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        SR <= 9'd0;
        NEG_DIVISOR <= 9'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        result <= 16'd0;
    end else if (opn_valid && !res_valid) begin
        // Initialize the shift register and NEG_DIVISOR
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= {1'b1, ~abs_divisor} + 1;
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Perform the division steps
        if (cnt == 8) begin
            // Division is complete, update the result
            remainder <= SR[7:0];
            quotient <= SR[8] ? (~SR[7:0] + 1) : SR[7:0];
            if (sign) begin
                if (is_dividend_negative ^ is_divisor_negative) begin
                    result <= {remainder, ~quotient + 1};
                end else begin
                    result <= {remainder, quotient};
                end
            end else begin
                result <= {remainder, quotient};
            end
            res_valid <= 1'b1;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
        end else begin
            // Compute the subtraction of NEG_DIVISOR
            carry_out <= SR[0] && !NEG_DIVISOR[0];
            if (SR[8:0] >= NEG_DIVISOR[8:0]) begin
                SR <= SR[8:0] - NEG_DIVISOR[8:0];
            end else begin
                SR <= SR[8:0];
            end
            // Update SR by shifting left and inserting the carry-out
            SR <= {SR[7:0], carry_out};
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Reset res_valid when the result is consumed
        res_valid <= 1'b0;
    end
end

endmodule