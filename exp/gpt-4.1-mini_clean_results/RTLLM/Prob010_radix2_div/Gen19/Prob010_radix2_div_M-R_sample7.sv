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

    // States
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers for sign and abs values
    reg dividend_sign, divisor_sign;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register: [15:8] remainder, [7:0] quotient
    reg [15:0] sr;

    // Counter for division steps
    reg [3:0] cnt;

    // Subtraction result and quotient bit for current cycle
    reg [8:0] sub_res;   // 9 bits to detect borrow
    reg       qbit;

    // Combinational next-state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (opn_valid) ? RUN : IDLE;
            RUN:   next_state = (cnt == 4'd8) ? DONE : RUN;
            DONE:  next_state = (opn_valid) ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for sign and absolute value
    wire dividend_sign_w = sign & dividend[7];
    wire divisor_sign_w  = sign & divisor[7];

    wire [7:0] dividend_abs_w = dividend_sign_w ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_w  = divisor_sign_w  ? (~divisor + 8'd1)  : divisor;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            sr           <= 16'd0;
            cnt          <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Latch inputs and sign info
                        dividend_sign <= dividend_sign_w;
                        divisor_sign  <= divisor_sign_w;
                        dividend_abs  <= dividend_abs_w;
                        divisor_abs   <= divisor_abs_w;
                        // Initialize shift register with dividend_abs in remainder, quotient=0
                        sr <= {dividend_abs_w, 8'd0};
                    end
                end

                RUN: begin
                    // Shift left by 1: remainder and quotient shift left by 1 bit
                    sr <= {sr[14:0], 1'b0};

                    // Perform subtraction of divisor_abs from remainder
                    sub_res = {1'b0, sr[15:8]} - {1'b0, divisor_abs};

                    if (sub_res[8] == 1'b0) begin
                        // No borrow -> set remainder to sub_res and quotient bit to 1
                        sr[15:8] <= sub_res[7:0];
                        sr[0]    <= 1'b1;
                    end else begin
                        // Borrow -> remainder unchanged, quotient bit = 0 (already zero after shift)
                        // No change needed for remainder or quotient bit (sr[0] is zero after shift)
                        sr[15:8] <= sr[15:8]; // explicit, though no change
                        sr[0]    <= 1'b0;
                    end

                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Apply sign correction to quotient and remainder if signed division
                    reg [7:0] quotient;
                    reg [7:0] remainder;
                    quotient  = sr[7:0];
                    remainder = sr[15:8];

                    if (sign) begin
                        if (dividend_sign ^ divisor_sign) begin
                            quotient = (~quotient) + 8'd1;
                        end
                        if (dividend_sign) begin
                            remainder = (~remainder) + 8'd1;
                        end
                    end

                    result    <= {remainder, quotient};
                    res_valid <= 1'b1;

                    // If new operation arrives immediately, restart RUN state and clear res_valid
                    if (opn_valid) begin
                        dividend_sign <= dividend_sign_w;
                        divisor_sign  <= divisor_sign_w;
                        dividend_abs  <= dividend_abs_w;
                        divisor_abs   <= divisor_abs_w;
                        sr <= {dividend_abs_w, 8'd0};
                        cnt <= 4'd0;
                        res_valid <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    sr <= 16'd0;
                end
            endcase
        end
    end
endmodule