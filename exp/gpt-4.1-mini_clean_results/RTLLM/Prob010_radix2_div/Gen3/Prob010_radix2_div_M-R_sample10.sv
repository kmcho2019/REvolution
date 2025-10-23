module radix2_div (
    input          clk,
    input          rst,
    input          sign,          // 1: signed division, 0: unsigned
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result       // {remainder[7:0], quotient[7:0]}
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        EXECUTE = 2'b01,
        DONE    = 2'b10
    } state_t;
    state_t state, next_state;

    reg [16:0] SR;         // Shift register: {remainder[8:0], quotient[7:0]} = 17 bits total
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;

    reg dividend_neg;
    reg divisor_neg;

    reg sign_quotient;
    reg sign_remainder;

    reg [3:0] cnt;

    // Subtraction signals
    wire [9:0] sub_res;
    wire       sub_borrow;

    wire [8:0] remainder = SR[16:8];  // Upper 9 bits: remainder (one extra bit for sign)
    wire [7:0] quotient  = SR[7:0];   // Lower 8 bits: quotient

    // Perform subtraction: remainder - divisor_abs
    assign {sub_borrow, sub_res} = {1'b0, remainder} - {1'b0, divisor_abs};

    // FSM: Sequential state update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            cnt <= 4'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture and prepare inputs: absolute values and sign info
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 1) : dividend;
                            divisor_abs  <= divisor[7]  ? (~divisor + 1)  : divisor;
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end

                        // Initialize SR: remainder = dividend_abs shifted left by 1 bit (9 bits)
                        // quotient = 0 initially
                        SR <= {9'd0, 8'd0};  // default zero, will update below

                        cnt <= 4'd0;
                    end
                end
                EXECUTE: begin
                    // Perform one division iteration per clock

                    // Shift SR left by 1 bit
                    // New quotient bit is initially zero
                    SR <= {SR[15:0], 1'b0};

                    cnt <= cnt + 1;

                    // After shift, check if subtraction remainder - divisor_abs >= 0 (no borrow)
                    if (!sub_borrow) begin
                        // If remainder >= divisor, update remainder and set quotient bit to 1
                        SR[16:8] <= sub_res[8:0];    // update remainder with subtraction result
                        SR[0] <= 1'b1;               // set LSB of quotient to 1 (newest bit)
                    end
                    // else remainder restored automatically by shifting in SR (no remainder update), quotient bit stays 0

                end
                DONE: begin
                    // Apply sign correction to quotient and remainder if signed

                    reg [7:0] corrected_quotient;
                    reg [7:0] corrected_remainder;

                    corrected_quotient = quotient;
                    corrected_remainder = remainder[7:0]; // discard extra MSB used in calculation

                    if (sign) begin
                        if (sign_quotient)
                            corrected_quotient = ~corrected_quotient + 1;
                        if (sign_remainder)
                            corrected_remainder = ~corrected_remainder + 1;
                    end

                    result <= {corrected_remainder, corrected_quotient};
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // FSM: Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    // After capturing input, initialize SR with dividend_abs shifted left by 1 bit
                    next_state = EXECUTE;
                end
            end
            EXECUTE: begin
                if (cnt == 4'd8) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // Stay in DONE until new operation begins
                if (!res_valid) begin
                    next_state = IDLE;
                end else if (opn_valid && res_valid) begin
                    // Start new operation immediately
                    next_state = EXECUTE;
                end
            end
        endcase
    end

    // SR initialization after capturing inputs, combinational to load dividend_abs shifted left by 1 bit
    always @(posedge clk) begin
        if (state == IDLE && opn_valid) begin
            // Load SR: remainder is dividend_abs shifted left by 1 bit = 9 bits,
            // quotient is zero
            // So upper 9 bits = {dividend_abs, 1'b0}, lower 8 bits = 0
            SR <= {dividend_abs, 1'b0, 8'd0};
        end
    end

endmodule