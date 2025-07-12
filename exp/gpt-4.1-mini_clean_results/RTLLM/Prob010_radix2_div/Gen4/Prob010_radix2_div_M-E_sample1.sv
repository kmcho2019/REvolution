module radix2_div (
    input           clk,
    input           rst,
    input           sign,           // 1: signed division, 0: unsigned division
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result        // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam CALC   = 2'b01;
    localparam FINISH = 2'b10;

    reg [1:0] state, next_state;

    // Internal registers
    reg [16:0] SR;           // Shift Register: {remainder[8:0], quotient[7:0]} = 17 bits total
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;
    reg       dividend_neg;
    reg       divisor_neg;

    reg       quotient_neg;
    reg       remainder_neg;

    reg [3:0] cnt;           // 0..8 iteration counter

    // Subtraction wires
    wire [9:0] sub_res;      // 9 bits remainder + 1 borrow bit
    wire       borrow;

    wire [8:0] remainder = SR[16:8];
    wire [7:0] quotient  = SR[7:0];

    // Subtraction: remainder - divisor_abs
    assign {borrow, sub_res} = {1'b0, remainder} - {1'b0, divisor_abs};

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            cnt <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Capture sign and absolute values
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 1) : dividend;
                            divisor_abs <= divisor[7] ? (~divisor + 1) : divisor;
                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                            quotient_neg <= 1'b0;
                            remainder_neg <= 1'b0;
                        end

                        // Initialize SR:
                        // remainder = dividend_abs shifted left by 1 (9 bits)
                        // quotient = 0
                        SR <= {dividend_abs, 1'b0, 8'd0};
                    end
                end

                CALC: begin
                    // Shift SR left by 1 (drop MSB remainder bit, shift remainder and quotient)
                    SR <= {SR[15:0], 1'b0};
                    cnt <= cnt + 1;

                    // If remainder >= divisor_abs (borrow == 0), update remainder and set quotient bit
                    if (!borrow) begin
                        // Apply subtraction result to remainder field and set LSB of quotient to 1
                        SR[16:8] <= sub_res[8:0];   // update remainder
                        SR[0] <= 1'b1;              // set quotient LSB to 1
                    end
                    // If borrow, quotient bit remains 0, remainder unmodified (because SR shifted left)

                end

                FINISH: begin
                    // Correct signs for quotient and remainder if signed operation
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    final_quotient = quotient;
                    final_remainder = remainder[7:0]; // drop the extra MSB used for calculation

                    if (sign) begin
                        if (quotient_neg)
                            final_quotient = ~final_quotient + 8'd1;
                        if (remainder_neg)
                            final_remainder = ~final_remainder + 8'd1;
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end

                default: ; // do nothing
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = CALC;
            end

            CALC: begin
                if (cnt == 4'd8)
                    next_state = FINISH;
            end

            FINISH: begin
                // Stay in FINISH until result consumed (signaled by opn_valid deassertion or new opn_valid)
                if (opn_valid == 1'b0)
                    next_state = IDLE;
                else
                    next_state = CALC; // start new division immediately if opn_valid stays high
            end
        endcase
    end

endmodule