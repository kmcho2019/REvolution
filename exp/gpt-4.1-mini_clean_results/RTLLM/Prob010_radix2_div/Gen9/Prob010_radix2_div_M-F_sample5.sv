module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_ready,
    output reg [15:0] result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;
    state_t state, next_state;

    reg [3:0] cnt;

    // Internal registers for sign and absolute values
    reg dividend_neg, divisor_neg, quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // 9-bit remainder, 8-bit quotient in a shift register SR: [16:8] remainder, [7:0] quotient
    reg [16:0] SR;

    // Compute absolute values for signed mode
    function [7:0] abs8(input [7:0] val);
        abs8 = (sign && val[7]) ? (~val + 8'd1) : val;
    endfunction

    // Two's complement functions for 8-bit and 9-bit
    function [7:0] twos_comp8(input [7:0] val);
        twos_comp8 = ~val + 8'd1;
    endfunction

    function [8:0] twos_comp9(input [8:0] val);
        twos_comp9 = ~val + 9'd1;
    endfunction

    // combinational neg_divisor
    wire [8:0] neg_divisor;
    assign neg_divisor = twos_comp9({1'b0, divisor_abs});

    // Internal wires for subtraction result
    wire [9:0] sub_res_ext; // one bit wider for subtraction carry

    // remainder is 9 bits in SR[16:8]
    assign sub_res_ext = {1'b0, SR[16:8]} + {1'b0, neg_divisor};

    // Next SR value calculation combinationally
    wire [16:0] SR_next;

    // If subtraction result is non-negative (MSB=0), remainder updates to sub_res, quotient shifts in 1
    // else remainder unchanged, quotient shifts in 0
    assign SR_next = (!sub_res_ext[9]) ?
        {sub_res_ext[8:0], SR[7:1], 1'b1} :   // subtract successful, quotient bit=1
        {SR[15:0], 1'b0};                     // subtract failed, quotient bit=0

    // Division by zero flag
    wire div_by_zero = (divisor_abs == 8'd0);

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            cnt          <= 4'd0;
            res_ready    <= 1'b0;
            result       <= 16'd0;
            SR           <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_ready <= 1'b0;
                    if (opn_valid) begin
                        // Latch inputs and initialize
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg  <= (sign && divisor[7]);
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg<= (sign && dividend[7]);

                        // Initialize SR with remainder = dividend_abs shifted left 1 bit (9-bit), quotient = 0
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        cnt <= 4'd1;
                    end
                end

                DIVIDE: begin
                    if (div_by_zero) begin
                        // Shift quotient bits in zero each cycle for 8 cycles
                        SR <= {SR[15:0], 1'b0};
                        cnt <= cnt + 1'b1;
                    end else begin
                        SR <= SR_next;
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    // Wait until new operation starts
                    res_ready <= 1'b1;
                end
            endcase
        end
    end

    // FSM combinational next state logic and output result preparation
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end

            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
            end

            DONE: begin
                if (opn_valid)
                    next_state = DIVIDE;
                else if (!opn_valid)
                    next_state = DONE;
            end
        endcase
    end

    // Apply sign correction and assign result when DONE state entered
    always @(posedge clk) begin
        if (rst) begin
            result <= 16'd0;
            res_ready <= 1'b0;
        end else if (state == DIVIDE && cnt == 4'd8) begin
            // Extract quotient and remainder from SR
            reg [7:0] q, r;
            reg [7:0] q_signed, r_signed;

            q = SR[7:0];
            r = SR[16:9];

            // Handle division by zero: set both quotient and remainder to zero
            if (div_by_zero) begin
                q = 8'd0;
                r = 8'd0;
            end

            if (sign) begin
                // Correct signs if needed
                q_signed = quotient_neg ? twos_comp8(q) : q;
                r_signed = remainder_neg ? twos_comp8(r) : r;
                result <= {r_signed, q_signed};
            end else begin
                result <= {r, q};
            end

            res_ready <= 1'b1;
        end else if (state == IDLE) begin
            res_ready <= 1'b0;  // Clear when no operation is in progress
        end
    end

endmodule