module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result       // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        DIVIDE  = 2'd1,
        DONE    = 2'd2
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg [7:0] abs_dividend, abs_divisor;
    reg       dividend_neg, divisor_neg;

    // 17-bit shift register: [16:8] remainder (9 bits), [7:0] quotient (8 bits)
    reg [16:0] shift_reg;

    // 4-bit counter for 8 iterations
    reg [3:0] count;

    // Trial subtraction wires
    wire [8:0] remainder;
    wire [8:0] subtract_res;
    wire       subtract_non_neg;

    // Temporary registers for sign correction
    reg [7:0] quotient_unsigned;
    reg [7:0] remainder_unsigned;

    // Functions to calculate absolute value and negation
    function [7:0] abs_val(input [7:0] val);
        abs_val = val[7] ? (~val + 8'd1) : val;
    endfunction

    function [7:0] neg_val(input [7:0] val);
        neg_val = ~val + 8'd1;
    endfunction

    // FSM combinational next_state logic
    always @(*) begin
        case(state)
            IDLE: 
                next_state = (opn_valid && !res_valid) ? DIVIDE : IDLE;
            DIVIDE: 
                next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE: 
                next_state = (opn_valid && !res_valid) ? DIVIDE : 
                             (!opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Extract remainder from shift register
    assign remainder = shift_reg[16:8];

    // Compute trial subtraction remainder - divisor
    assign subtract_res = remainder - {1'b0, abs_divisor};

    // Check if subtraction result is non-negative (MSB=0 means no borrow)
    assign subtract_non_neg = ~subtract_res[8];

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            shift_reg      <= 17'd0;
            count          <= 4'd0;
            abs_dividend   <= 8'd0;
            abs_divisor    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_unsigned <= 8'd0;
            remainder_unsigned <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;

                    if (opn_valid && !res_valid) begin
                        // Capture sign and absolute values
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            abs_dividend <= abs_val(dividend);
                            abs_divisor  <= abs_val(divisor);
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor  <= divisor;
                        end

                        // Initialize shift register: remainder=0, quotient=abs_dividend
                        // Shift reg: {9'd0, abs_dividend[7:0]}
                        shift_reg <= {9'd0, abs_dividend};
                    end
                end

                DIVIDE: begin
                    // Each cycle: 
                    // 1) Shift left by 1 bit (remainder and quotient combined)
                    // 2) Trial subtract divisor from remainder
                    // 3) If subtraction non-negative, accept result and set quotient LSB=1, else restore and quotient LSB=0

                    // Shift left combined remainder and quotient by 1
                    // First shift
                    // Temporarily shift left
                    reg [16:0] shifted;
                    shifted = {shift_reg[15:0], 1'b0};

                    // Perform trial subtraction on new remainder (upper 9 bits)
                    // If subtraction non-negative, update remainder and set quotient LSB to 1
                    if (subtract_non_neg) begin
                        // Set remainder to subtract_res and set quotient bit 0 to 1
                        shift_reg <= {subtract_res, shifted[7:1], 1'b1};
                    end else begin
                        // Subtraction negative, restore remainder (shifted remainder before subtraction)
                        // Quotient LSB remains 0
                        shift_reg <= shifted;
                    end

                    count <= count + 1'b1;
                end

                DONE: begin
                    // Store unsigned quotient and remainder extracted from shift_reg
                    quotient_unsigned  <= shift_reg[7:0];
                    remainder_unsigned <= shift_reg[16:9];

                    res_valid <= 1'b1;

                    // Keep result stable until new operation starts
                    if (opn_valid && !res_valid) begin
                        res_valid <= 1'b0;
                        count <= 4'd0;
                        // Next operation will be handled in IDLE
                    end
                end

                default: ;
            endcase
        end
    end

    // Sign correction and division-by-zero handling
    always @(*) begin
        reg [7:0] q;
        reg [7:0] r;

        if (state == DONE) begin
            // Divisor zero case
            if (abs_divisor == 8'd0) begin
                // quotient=0xFF, remainder=dividend (signed/unsigned)
                q = 8'hFF;
                r = (sign && dividend_neg) ? neg_val(abs_dividend) : abs_dividend;
            end else if (sign) begin
                // Signed division: apply sign to quotient and remainder
                // Quotient sign = dividend_neg ^ divisor_neg
                if (dividend_neg ^ divisor_neg)
                    q = neg_val(quotient_unsigned);
                else
                    q = quotient_unsigned;

                // Remainder sign = dividend sign
                if (dividend_neg)
                    r = neg_val(remainder_unsigned);
                else
                    r = remainder_unsigned;
            end else begin
                // Unsigned division, pass values directly
                q = quotient_unsigned;
                r = remainder_unsigned;
            end
        end else begin
            q = 8'd0;
            r = 8'd0;
        end

        result = {r, q};
    end

endmodule