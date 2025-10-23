module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'b00,
        PREPARE = 2'b01,
        DIVIDE  = 2'b10,
        DONE    = 2'b11
    } state_t;

    state_t state, next_state;

    // Registers to hold inputs and intermediate values
    reg [7:0]  dividend_reg;
    reg [7:0]  divisor_reg;

    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    reg [16:0] SR;          // Shift register: remainder(9 bits) + quotient(8 bits)
    reg [8:0]  neg_divisor; // 9-bit two's complement of divisor_abs
    reg [3:0]  cnt;         // counter from 0 to 8

    wire divisor_zero = (divisor_reg == 8'd0);

    // Absolute values combinational (used only in PREPARE state)
    wire [7:0] dividend_abs_comb = (sign && dividend_reg[7]) ? (~dividend_reg + 8'd1) : dividend_reg;
    wire [7:0] divisor_abs_comb  = (sign && divisor_reg[7])  ? (~divisor_reg  + 8'd1) : divisor_reg;

    // Subtraction calculation for the division step
    wire [9:0] remainder_ext = {1'b0, SR[16:8]}; // 9 bits remainder extended to 10 bits
    wire [9:0] sub_res = remainder_ext + neg_divisor; // remainder - divisor_abs (since neg_divisor = -divisor_abs)
    wire       sub_no_borrow = sub_res[9]; // borrow flag (1 means no borrow, i.e. remainder >= divisor)

    // Wires to hold SR next value in DIVIDE state
    reg [16:0] SR_next;

    // Outputs after sign correction
    reg [7:0] quotient_out;
    reg [7:0] remainder_out;

    // FSM sequential block
    always @(posedge clk) begin
        if (rst) begin
            state         <= IDLE;
            dividend_reg  <= 8'd0;
            divisor_reg   <= 8'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;
            SR            <= 17'd0;
            neg_divisor   <= 9'd0;
            cnt           <= 4'd0;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            quotient_out  <= 8'd0;
            remainder_out <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg  <= divisor;
                    end
                end
                PREPARE: begin
                    // Compute abs and sign flags
                    dividend_abs  <= dividend_abs_comb;
                    divisor_abs   <= divisor_abs_comb;
                    dividend_neg  <= (sign) ? dividend_reg[7] : 1'b0;
                    divisor_neg   <= (sign) ? divisor_reg[7]  : 1'b0;
                    quotient_neg  <= (sign) ? (dividend_reg[7] ^ divisor_reg[7]) : 1'b0;
                    remainder_neg <= (sign) ? dividend_reg[7] : 1'b0;

                    // Initialize SR: remainder = dividend_abs shifted left by 1 bit in upper 9 bits
                    // quotient = 0 initially
                    SR <= {dividend_abs_comb, 1'b0, 8'd0};

                    // neg_divisor = - divisor_abs extended to 9 bits
                    neg_divisor <= (~{1'b0, divisor_abs_comb} + 9'd1);

                    cnt <= 4'd1;
                end
                DIVIDE: begin
                    // Perform one division step
                    if (sub_no_borrow) begin
                        // remainder >= divisor: update remainder and set quotient bit to 1
                        SR_next = {sub_res[8:0], SR[7:0], 1'b1};
                    end else begin
                        // remainder < divisor: shift left and set quotient bit 0
                        SR_next = {SR[15:0], 1'b0};
                    end
                    SR <= SR_next;
                    cnt <= cnt + 4'd1;
                end
                DONE: begin
                    // Apply sign correction to quotient and remainder
                    quotient_out <= quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];
                    remainder_out <= remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];
                    result <= {remainder_out, quotient_out};
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = PREPARE;
            end
            PREPARE: begin
                if (divisor_zero)
                    next_state = DONE; // division by zero, skip division
                else
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (cnt == 4'd9) // completed 8 iterations, cnt started at 1
                    next_state = DONE;
            end
            DONE: begin
                // Wait for opn_valid low before returning to IDLE
                if (!opn_valid)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule