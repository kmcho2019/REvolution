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

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Absolute values and signs
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_sign, divisor_sign;

    // Remainder and quotient combined: upper 8 bits remainder, lower 8 bits quotient
    reg [15:0] sr;

    // Counter for 8 division steps
    reg [3:0] cnt;

    // Internal subtraction result (9 bits to detect borrow)
    reg [8:0] sub_res;

    // Quotient bit to set this cycle
    reg q_bit;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (opn_valid) ? RUN  : IDLE;
            RUN:   next_state = (cnt == 4'd8) ? DONE : RUN;
            DONE:  next_state = (opn_valid) ? RUN  : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sign and absolute value logic (combinational)
    wire dividend_sign_w = sign & dividend[7];
    wire divisor_sign_w  = sign & divisor[7];

    wire [7:0] dividend_abs_w = dividend_sign_w ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_w  = divisor_sign_w  ? (~divisor + 1)  : divisor;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            sr          <= 16'd0;
            cnt         <= 4'd0;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_abs <= dividend_abs_w;
                        divisor_abs  <= divisor_abs_w;
                        dividend_sign<= dividend_sign_w;
                        divisor_sign <= divisor_sign_w;
                        // Load dividend_abs into remainder (upper 8 bits), quotient cleared
                        sr <= {dividend_abs_w, 8'd0};
                        cnt <= 4'd0;
                    end
                end

                RUN: begin
                    // Shift left sr by 1 to bring next dividend bit into remainder
                    sr <= sr << 1;

                    // Subtract divisor_abs from remainder (upper 8 bits)
                    sub_res = {1'b0, sr[15:8]} - {1'b0, divisor_abs};

                    if (sub_res[8] == 0) begin
                        // Subtraction no borrow => remainder updated, quotient bit set to 1
                        sr[15:8] <= sub_res[7:0];
                        sr[0]    <= 1'b1; // set LSB quotient bit
                    end else begin
                        // Subtraction borrow => remainder unchanged, quotient bit set to 0
                        // sr remainder stays the same (after shift)
                        sr[0]    <= 1'b0;
                    end
                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Correct quotient and remainder sign if signed division
                    reg [7:0] quotient = sr[7:0];
                    reg [7:0] remainder = sr[15:8];

                    if (sign) begin
                        // quotient sign = dividend_sign ^ divisor_sign
                        if (dividend_sign ^ divisor_sign)
                            quotient = (~quotient + 1);
                        // remainder sign = dividend_sign
                        if (dividend_sign)
                            remainder = (~remainder + 1);
                    end

                    result <= {remainder, quotient};
                    res_valid <= 1'b1;

                    if (opn_valid) begin
                        // Start new operation
                        dividend_abs <= dividend_abs_w;
                        divisor_abs  <= divisor_abs_w;
                        dividend_sign<= dividend_sign_w;
                        divisor_sign <= divisor_sign_w;
                        sr <= {dividend_abs_w, 8'd0};
                        cnt <= 4'd0;
                        res_valid <= 1'b0;
                    end
                end

                default: begin
                    // default safe
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    sr <= 16'd0;
                end
            endcase
        end
    end
endmodule