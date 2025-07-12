module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1 = signed operation, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Registers for input capturing and processing
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;

    reg       dividend_neg;
    reg       divisor_neg;

    // Absolute values for division
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Combined remainder and quotient shift register
    // Upper 9 bits: remainder (with one extra bit for subtract), lower 8 bits: quotient
    reg [16:0] SR;

    reg [3:0] count;  // iteration counter: 0 to 8

    // Internal wires for subtraction
    wire [8:0] remainder_part = SR[16:8];          // upper 9 bits remainder
    wire [8:0] sub_res = remainder_part - {1'b0, divisor_abs};
    wire       borrow = sub_res[8];                 // borrow if sub_res < 0

    // Next remainder after conditional subtract
    wire [8:0] next_remainder = borrow ? remainder_part : sub_res;

    // Next quotient bit to shift in
    wire next_quotient_bit = borrow ? 1'b0 : 1'b1;

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'b0;
            SR          <= 17'b0;
            count       <= 4'd0;
            dividend_reg<= 8'b0;
            divisor_reg <= 8'b0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            dividend_abs<= 8'b0;
            divisor_abs <= 8'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;

                    if (opn_valid) begin
                        // Capture inputs
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            // Convert to absolute values
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                        end

                        // Initialize SR: remainder = 0, quotient = 0, then load dividend_abs shifted left 1 into remainder bits
                        // We will start remainder as 0, quotient 0, and shift dividend_abs into remainder gradually.
                        // Alternatively, set remainder = 0 and quotient = dividend_abs, then shift from quotient bits?
                        // Traditional approach: remainder=0, quotient=dividend_abs

                        // But here, we load dividend_abs into lower quotient bits, remainder starts zero.
                        // Non-restoring algorithm: remainder = 0, quotient = dividend_abs
                        SR <= {9'd0, dividend_abs}; // remainder upper 9 bits zero, quotient lower 8 bits dividend_abs
                    end
                end

                DIVIDE: begin
                    count <= count + 1'b1;

                    // Perform subtraction or restore remainder depending on borrow
                    // Shift left by 1 bit: {remainder, quotient} << 1
                    // New remainder upper bits assigned conditionally
                    // After shift left, insert next quotient bit into LSB of quotient part

                    // Construct next SR:
                    // First shift remainder and quotient left by 1:
                    // SR[16:0] << 1 = {SR[15:0], 1'b0}
                    // Then update remainder bits upper 9 bits:
                    // next remainder bits = next_remainder after subtract if no borrow, else unchanged
                    // quotient LSB = next_quotient_bit

                    // So:
                    // New SR = {next_remainder[8:0], SR[7:1], next_quotient_bit}

                    SR <= {next_remainder, SR[7:1], next_quotient_bit};
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Hold result until next operation or reset
                end
            endcase
        end
    end

    // FSM combinational next-state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (opn_valid && divisor != 8'b0) begin
                    next_state = DIVIDE;
                end else begin
                    next_state = IDLE;
                end
            end

            DIVIDE: begin
                if (count == 4'd8) begin
                    next_state = DONE;
                end else begin
                    next_state = DIVIDE;
                end
            end

            DONE: begin
                if (opn_valid) begin
                    next_state = DIVIDE;
                end else begin
                    next_state = DONE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Sign correction and result assignment at DONE state
    always @(posedge clk) begin
        if (rst) begin
            result <= 16'b0;
        end else if (state == DONE) begin
            // Extract quotient and remainder
            // quotient in SR[7:0], remainder in SR[16:9] (upper 8 bits)
            reg [7:0] raw_quotient;
            reg [7:0] raw_remainder;
            reg [7:0] corrected_quotient;
            reg [7:0] corrected_remainder;

            raw_quotient  = SR[7:0];
            raw_remainder = SR[16:9];

            // Apply sign corrections if signed mode
            if (sign) begin
                // quotient sign = dividend_neg ^ divisor_neg
                if (dividend_neg ^ divisor_neg)
                    corrected_quotient = (~raw_quotient + 8'd1);
                else
                    corrected_quotient = raw_quotient;

                // remainder sign = dividend_neg
                if (dividend_neg)
                    corrected_remainder = (~raw_remainder + 8'd1);
                else
                    corrected_remainder = raw_remainder;
            end else begin
                corrected_quotient = raw_quotient;
                corrected_remainder = raw_remainder;
            end

            result <= {corrected_remainder, corrected_quotient};
        end
    end

endmodule