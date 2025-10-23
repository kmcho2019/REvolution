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

    // States for FSM
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state, next_state;

    // Registers as per problem
    reg [16:0] SR;            // Shift register holds remainder+quotient bits + 1 bit (17 bits)
    reg [8:0]  NEG_DIVISOR;   // Negative divisor (9 bits)
    reg [3:0]  cnt;           // Counter for 8 division steps (0..8)
    reg start_cnt;

    // Input sign and absolute values
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_neg, divisor_neg;
    reg       quotient_neg, remainder_neg;

    // Temporary variables declared outside always blocks
    reg [7:0] remainder_out;
    reg [7:0] quotient_out;

    // Function to get absolute value with sign consideration
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 1'b1;
            else
                abs8 = val;
        end
    endfunction

    // Compute subtraction result (SR[16:8] + NEG_DIVISOR)
    wire [8:0] sub_res;        // 9-bit subtraction result
    wire       sub_carry;      // borrow indicator (carry in addition)

    assign {sub_carry, sub_res} = {1'b0, SR[16:8]} + NEG_DIVISOR; // add negative divisor

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (opn_valid && !res_valid)
                    next_state = BUSY;
                else
                    next_state = IDLE;
            BUSY:
                if (cnt == 4'd8)
                    next_state = IDLE;
                else
                    next_state = BUSY;
            default:
                next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            SR           <= 17'd0;
            NEG_DIVISOR  <= 9'd0;
            cnt          <= 4'd0;
            start_cnt    <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            remainder_out<= 8'd0;
            quotient_out <= 8'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= (res_valid && opn_valid) ? res_valid : 1'b0; // clear res_valid if not busy

                    if (opn_valid && !res_valid) begin
                        // Capture absolute values and signs
                        dividend_abs  <= abs8(dividend);
                        divisor_abs   <= abs8(divisor);

                        dividend_neg  <= sign ? dividend[7] : 1'b0;
                        divisor_neg   <= sign ? divisor[7] : 1'b0;
                        quotient_neg  <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= sign ? dividend[7] : 1'b0;

                        // Initialize SR with dividend_abs shifted left by 1 (append 0 LSB)
                        SR <= {dividend_abs, 1'b0};

                        // Compute NEG_DIVISOR = -divisor_abs extended to 9 bits
                        // if divisor_abs==0, NEG_DIVISOR=0 to avoid invalid subtraction
                        NEG_DIVISOR <= (divisor_abs != 8'd0) ? (~{1'b0, divisor_abs} + 1'b1) : 9'd0;

                        cnt <= 4'd0;     // will start from 0, increment at iteration
                        start_cnt <= 1'b1;
                        res_valid <= 1'b0;
                    end
                end

                BUSY: begin
                    start_cnt <= 1'b1;

                    // Perform iteration step
                    if (cnt < 4'd8) begin
                        if (sub_carry) begin
                            // subtraction succeeded, update upper bits of SR with sub_res and shift left insert 1
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // subtraction failed, shift left insert 0
                            SR <= {SR[15:0], 1'b0};
                        end
                        cnt <= cnt + 4'd1;
                        res_valid <= 1'b0;
                    end

                    if (cnt == 4'd8) begin
                        // Division complete: extract remainder and quotient from SR
                        remainder_out <= SR[16:9];
                        quotient_out  <= SR[8:1];

                        // Adjust signs if signed operation
                        if (sign) begin
                            if (quotient_neg)
                                quotient_out <= (~quotient_out) + 1'b1;
                            if (remainder_neg)
                                remainder_out <= (~remainder_out) + 1'b1;
                        end

                        // Output result: remainder[15:8], quotient[7:0]
                        result <= {remainder_out, quotient_out};
                        res_valid <= 1'b1;
                        start_cnt <= 1'b0;
                    end
                end

                default: begin
                    // default safe state
                    state <= IDLE;
                    res_valid <= 1'b0;
                end
            endcase

            // Clear res_valid if result consumed and new operation started
            if (res_valid && opn_valid && state == IDLE) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule