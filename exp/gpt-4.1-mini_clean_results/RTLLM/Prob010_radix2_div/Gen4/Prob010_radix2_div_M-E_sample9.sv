module radix2_div (
    input             clk,
    input             rst,
    input             sign,            // 1: signed division; 0: unsigned division
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result            // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers to hold latched inputs
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;  // sign bits for inputs
    reg       quotient_neg, remainder_neg;

    // Absolute values for division
    wire [7:0] dividend_abs = (sign && dividend_reg[7]) ? (~dividend_reg + 8'd1) : dividend_reg;
    wire [7:0] divisor_abs  = (sign && divisor_reg[7])  ? (~divisor_reg + 8'd1)  : divisor_reg;

    // Remainder and quotient registers
    reg [8:0] remainder;    // 9 bits to allow subtraction and shift (MSB is sign/overflow bit)
    reg [7:0] quotient;

    reg [3:0] count;        // counts division cycles 0..7

    // Subtraction result signals
    wire [8:0] remainder_sub;
    wire       remainder_sub_sign; // 1 if negative result (borrow)

    assign remainder_sub = remainder - {1'b0, divisor_abs}; // subtract divisor_abs from remainder
    assign remainder_sub_sign = remainder_sub[8];          // sign bit: 1 if negative

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (opn_valid) ? DIVIDE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_reg <= 8'd0;
            divisor_reg  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            remainder    <= 9'd0;
            quotient     <= 8'd0;
            count        <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    quotient <= 8'd0;
                    remainder <= 9'd0;
                    count <= 4'd0;

                    if(opn_valid) begin
                        // Latch inputs
                        dividend_reg <= dividend;
                        divisor_reg  <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg<= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            quotient_neg <= 1'b0;
                            remainder_neg<= 1'b0;
                        end

                        // Initialize remainder with 0, quotient with dividend_abs
                        remainder <= 9'd0;
                        quotient  <= dividend_abs;
                    end
                end

                DIVIDE: begin
                    // Shift left {remainder, quotient} by 1 bit
                    // New remainder is (remainder << 1) + MSB of quotient
                    // New quotient will be updated after subtraction check

                    // Calculate next remainder candidate
                    reg [8:0] rem_shifted;
                    reg [7:0] quot_shifted;
                    reg [7:0] quot_new;

                    rem_shifted = {remainder[7:0], quotient[7]};
                    quot_shifted = {quotient[6:0], 1'b0};

                    // Attempt subtraction
                    if ((rem_shifted - {1'b0, divisor_abs})[8] == 1'b0) begin
                        // Subtraction successful (non-negative remainder)
                        remainder <= rem_shifted - {1'b0, divisor_abs};
                        quotient  <= quot_shifted | 8'b00000001; // set LSB to 1
                    end else begin
                        // Subtraction failed, restore remainder
                        remainder <= rem_shifted;
                        quotient  <= quot_shifted; // LSB = 0
                    end

                    count <= count + 1'b1;
                end

                DONE: begin
                    // Apply sign correction to quotient and remainder (if signed)
                    reg [7:0] q_final, r_final;

                    // quotient and remainder before sign fix are positive magnitude
                    q_final = quotient_neg ? (~quotient + 8'd1) : quotient;
                    r_final = remainder_neg ? (~remainder[7:0] + 8'd1) : remainder[7:0];

                    result    <= {r_final, q_final};
                    res_valid <= 1'b1;

                    if(opn_valid) begin
                        res_valid <= 1'b0;
                        // Next cycle moves to DIVIDE state automatically
                    end
                end

                default: ;
            endcase
        end
    end

endmodule