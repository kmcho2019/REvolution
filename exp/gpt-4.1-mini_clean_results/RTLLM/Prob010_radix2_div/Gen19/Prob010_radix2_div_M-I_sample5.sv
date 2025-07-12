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

    // State encoding
    typedef enum reg [1:0] {IDLE = 2'd0, DIVIDE = 2'd1, DONE = 2'd2} state_t;
    state_t state, next_state;

    // Internal registers for absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       dividend_sign;
    reg       divisor_sign;

    // Quotient and remainder registers
    reg [8:0] remainder;    // 9 bits to hold remainder with sign bit during subtraction trial
    reg [7:0] quotient;

    // Iteration counter for 8 division steps
    reg [3:0] cnt;

    // Trial subtraction signals
    wire [8:0] subtract_res;        // 9-bit subtraction result (remainder - divisor_abs)
    wire       subtract_nonneg;     // subtraction >= 0 if MSB (sign bit) == 0

    // Functions for absolute and negate
    function [7:0] abs8(input [7:0] val);
        begin
            abs8 = val[7] ? (~val + 1'b1) : val;
        end
    endfunction

    function [7:0] neg8(input [7:0] val);
        begin
            neg8 = ~val + 1'b1;
        end
    endfunction

    // Combinational subtract remainder - divisor_abs
    assign subtract_res = {1'b0, remainder[7:0]} - {1'b0, divisor_abs};
    assign subtract_nonneg = (subtract_res[8] == 1'b0);

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: 
                if (opn_valid) begin
                    if (divisor == 8'd0)
                        next_state = DONE;
                    else
                        next_state = DIVIDE;
                end else
                    next_state = IDLE;
            DIVIDE: 
                if (cnt == 4'd8) 
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            DONE:
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and division process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers and outputs
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            remainder     <= 9'd0;
            quotient      <= 8'd0;
            cnt           <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs and absolute values
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
                        quotient  <= 8'd0;
                        // Initialize remainder with 0, but we load dividend_abs shifted left 1 bit in quotient 
                        // We implement shift-left of remainder and quotient as combined
                        // Start remainder = 0, quotient = dividend_abs (will shift in bits during DIVIDE)
                        remainder <= 9'd0;
                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    // Shift left remainder:quotient combined by 1 bit
                    // Combined width = 17 bits: remainder(9) concat quotient(8)
                    // Shift left: upper bits shift, new LSB of quotient filled next cycle
                    // But we do stepwise:

                    // 1) Shift left remainder and quotient by 1 bit:
                    //   remainder = {remainder[7:0], quotient[7]} (shift left remainder by 1, bit shifted in from MSB quotient)
                    //   quotient = {quotient[6:0], 1'b0} (shift left quotient by 1, last bit to be decided)

                    // Implement shift first
                    remainder <= {remainder[7:0], quotient[7]};
                    quotient  <= {quotient[6:0], 1'b0};

                    // 2) Trial subtraction: remainder - divisor_abs
                    //    If subtract_nonneg, remainder = subtract_res[7:0], quotient LSB = 1
                    if (subtract_nonneg) begin
                        remainder <= subtract_res;
                        quotient[0] <= 1'b1; // Set LSB of quotient to 1
                    end
                    // else remainder remains shifted, quotient LSB already 0 from shift

                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    res_valid <= 1'b1;

                    if (divisor_abs == 8'd0) begin
                        // Division by zero special case
                        result <= {dividend_abs, 8'hFF}; // remainder = dividend_abs, quotient = 0xFF
                    end else if (sign) begin
                        // Signed division: apply sign corrections
                        // quotient sign = dividend_sign ^ divisor_sign
                        // remainder sign = dividend_sign
                        reg [7:0] quotient_signed;
                        reg [7:0] remainder_signed;

                        if (dividend_sign ^ divisor_sign)
                            quotient_signed = neg8(quotient);
                        else
                            quotient_signed = quotient;

                        if (dividend_sign)
                            remainder_signed = neg8(remainder[7:0]);
                        else
                            remainder_signed = remainder[7:0];

                        result <= {remainder_signed, quotient_signed};
                    end else begin
                        // Unsigned division, no sign corrections
                        result <= {remainder[7:0], quotient};
                    end

                    // Clear res_valid when opn_valid goes low (handshake)
                    if (!opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule