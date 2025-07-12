module radix2_div(
    input             clk,
    input             rst,
    input             sign,          // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // States
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Registers to hold input operands and signs
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;

    reg       dividend_neg;
    reg       divisor_neg;
    reg       sign_quotient;    // sign of the quotient
    reg       sign_remainder;   // sign of the remainder

    // Absolute values (calculated after loading inputs)
    wire [7:0] dividend_abs = (sign && dividend_neg) ? (~dividend_reg + 1'b1) : dividend_reg;
    wire [7:0] divisor_abs  = (sign && divisor_neg)  ? (~divisor_reg + 1'b1)  : divisor_reg;

    // 17-bit shift register: 
    // Upper 9 bits hold remainder (extra MSB for possible borrow)
    // Lower 8 bits hold quotient bits
    reg [16:0] SR;

    // Iteration counter for 8 steps
    reg [3:0] count;

    // Subtraction logic: (Remainder - Divisor)
    wire [8:0] remainder_part = SR[16:8];
    wire [8:0] subtract_result = remainder_part - {1'b0, divisor_abs};
    wire       subtraction_success = ~subtract_result[8]; // borrow bit is MSB: 0 means no borrow

    // Next SR value calculation
    wire [16:0] SR_shifted = {SR[15:0], 1'b0};  // shift left by 1 bit
    wire [16:0] SR_next = subtraction_success 
                        ? {subtract_result, SR[7:1], 1'b1}  // set LSB quotient bit to 1
                        : SR_shifted;                       // quotient bit 0

    // Sign correction wires
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    reg [7:0] quotient_corrected;
    reg [7:0] remainder_corrected;

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            count <= 4'd0;

            dividend_reg <= 8'd0;
            divisor_reg <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch inputs
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        // Capture signs if signed division
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end

                        // Initialize shift register:
                        // remainder = dividend_abs shifted left by 1 bit (9 bits)
                        // quotient = 0
                        SR <= {1'b0, dividend_abs, 8'd0};

                        count <= 4'd0;
                    end
                end

                DIVIDE: begin
                    SR <= SR_next;
                    count <= count + 1'b1;
                end

                DONE: begin
                    // Extract raw quotient and remainder from shift register
                    quotient_raw <= SR[7:0];
                    remainder_raw <= SR[16:9];

                    // Apply sign correction on quotient
                    quotient_corrected <= sign_quotient ? (~SR[7:0] + 1'b1) : SR[7:0];
                    // Apply sign correction on remainder
                    remainder_corrected <= sign_remainder ? (~SR[16:9] + 1'b1) : SR[16:9];

                    // Output result
                    result <= {remainder_corrected, quotient_corrected};
                    res_valid <= 1'b1;

                    // If a new operation starts, clear res_valid next cycle
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end

                default: begin
                    // should not happen, reset state
                    state <= IDLE;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (opn_valid) 
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end

            DIVIDE: begin
                if (count == 4'd8)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            end

            DONE: begin
                if (opn_valid)
                    next_state = DIVIDE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule