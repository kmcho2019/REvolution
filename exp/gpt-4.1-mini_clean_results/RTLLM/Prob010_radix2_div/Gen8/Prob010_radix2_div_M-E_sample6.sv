module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    reg [3:0] count;               // iteration counter: 0..8
    reg [8:0] remainder;           // 9-bit remainder register (extra bit for shift and subtract)
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [7:0] quotient;

    // Compute absolute values and signs
    function [7:0] abs8(input [7:0] val);
        begin
            abs8 = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Two's complement 8-bit
    function [7:0] twos_comp8(input [7:0] val);
        begin
            twos_comp8 = ~val + 8'd1;
        end
    endfunction

    // Two's complement 9-bit
    function [8:0] twos_comp9(input [8:0] val);
        begin
            twos_comp9 = ~val + 9'd1;
        end
    endfunction

    // Sign extend divisor_abs to 9 bits for subtraction
    wire [8:0] divisor_9 = {1'b0, divisor_abs};

    // Next remainder candidate after subtracting divisor
    wire [8:0] rem_sub = remainder - divisor_9;

    // Control signals for iteration
    wire subtract_success = (rem_sub[8] == 1'b0); // If MSB 0 => non-negative

    // Sequential FSM and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            remainder    <= 9'd0;
            divisor_abs  <= 8'd0;
            dividend_abs <= 8'd0;
            quotient     <= 8'd0;
            count        <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    quotient  <= 8'd0;
                    count     <= 4'd0;
                    if (opn_valid) begin
                        // Latch inputs and compute absolute values and signs
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg  <= (sign && divisor[7]);
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg<= (sign && dividend[7]);

                        // Initialize remainder with dividend_abs shifted left by 1 (9-bit)
                        remainder <= {1'b0, dividend_abs} << 1;

                        quotient <= 8'd0;
                        count <= 4'd0;
                    end
                end

                RUN: begin
                    if (count < 8) begin
                        remainder <= remainder << 1; // shift left by 1

                        // Try subtracting divisor_abs from remainder shifted left
                        // subtraction result is rem_sub = remainder - divisor_9
                        // Use subtract_success to decide quotient bit and remainder update

                        if (subtract_success) begin
                            // Successful subtraction: update remainder and set quotient bit
                            remainder <= rem_sub;
                            quotient <= {quotient[6:0], 1'b1};
                        end else begin
                            // Failed subtraction: remainder unchanged, quotient bit 0
                            quotient <= {quotient[6:0], 1'b0};
                        end
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    // Sign correction if needed
                    reg [7:0] signed_quotient;
                    reg [7:0] signed_remainder;

                    // Pre-correct results
                    signed_quotient  = quotient;
                    signed_remainder = remainder[8:1]; // remainder is 9 bits, upper 8 bits after shifting back

                    if (sign) begin
                        if (quotient_neg)
                            signed_quotient = twos_comp8(quotient);
                        if (remainder_neg)
                            signed_remainder = twos_comp8(remainder[8:1]);
                    end

                    result    <= {signed_remainder, signed_quotient};
                    res_valid <= 1'b1;
                end
            endcase

            // Handle division by zero: produce zero output and done immediately
            if (state == IDLE && opn_valid && divisor == 8'd0) begin
                remainder <= 9'd0;
                quotient  <= 8'd0;
                res_valid <= 1'b1;
                result    <= 16'd0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0)
                    next_state = RUN;
                else if (opn_valid && divisor == 8'd0)
                    next_state = DONE; // immediate done for div by zero
            end

            RUN: begin
                if (count == 8)
                    next_state = DONE;
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule