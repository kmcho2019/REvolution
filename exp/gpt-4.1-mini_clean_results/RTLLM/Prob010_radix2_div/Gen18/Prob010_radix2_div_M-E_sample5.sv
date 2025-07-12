module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result          // [15:8]: remainder, [7:0]: quotient
);

    localparam IDLE   = 2'b00;
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    reg [3:0] cnt; // counts 0..8
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [8:0] divisor_abs;    // 9 bits for divisor (with zero extension)
    reg [7:0] dividend_abs;   // 8 bits for dividend absolute value

    reg [16:0] SR; // {remainder(9 bits), quotient(8 bits)} plus 1 bit for shifting

    wire divisor_zero = (divisor_abs == 9'd0);

    // Compute absolute values
    wire [7:0] dividend_abs_w = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [8:0] divisor_abs_w  = (sign && divisor[7]) ? {1'b0, (~divisor + 8'd1)} : {1'b0, divisor};

    // Subtraction: remainder (9 bits) - divisor_abs (9 bits)
    wire signed [9:0] remainder_sub = {1'b0, SR[16:8]} - {1'b0, divisor_abs};

    // Sequential state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            cnt         <= 4'd0;
            SR          <= 17'd0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch input signs and abs values
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg  <= (sign && divisor[7]);

                        dividend_abs <= dividend_abs_w;
                        divisor_abs  <= divisor_abs_w;

                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg<= (sign && dividend[7]);

                        // Initialize shift register:
                        // remainder initialized with dividend_abs shifted left 1 bit
                        // quotient initialized 0
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_zero) begin
                        // Division by zero: quotient=0, remainder=dividend_abs
                        SR <= {dividend_abs, 8'd0};
                        cnt <= 4'd8; // jump to done after finishing iterations
                    end else if (cnt < 4'd8) begin
                        // Shift SR left by 1 bit
                        // Calculate remainder - divisor
                        // If remainder_sub >= 0 => subtract, set quotient bit = 1
                        // Else keep remainder, quotient bit = 0
                        reg [16:0] next_SR;
                        reg subtract_ok;
                        subtract_ok = (remainder_sub >= 0);

                        next_SR = {SR[15:0], 1'b0}; // shift left by 1 bit

                        if (subtract_ok) begin
                            // Replace remainder with subtracted value
                            next_SR[16:8] = remainder_sub[8:0];
                            next_SR[0] = 1'b1;
                        end else begin
                            next_SR[0] = 1'b0;
                        end

                        SR <= next_SR;
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    // Nothing to do, wait for next opn_valid
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: if (opn_valid) next_state = DIVIDE;
            DIVIDE: if (cnt == 4'd8) next_state = DONE;
            DONE: if (!opn_valid) next_state = IDLE;
        endcase
    end

    // Output logic and sign correction (combinational)
    always @(*) begin
        if(state == DONE) begin
            // Extract raw quotient and remainder
            // remainder: bits [16:9], quotient: [7:0]
            // sign correction by two's complement if negative
            reg [7:0] raw_quotient;
            reg [7:0] raw_remainder;
            reg [7:0] corr_quotient;
            reg [7:0] corr_remainder;

            raw_quotient  = SR[7:0];
            raw_remainder = SR[16:9];

            corr_quotient = quotient_neg ? (~raw_quotient + 1'b1) : raw_quotient;
            corr_remainder= remainder_neg? (~raw_remainder + 1'b1): raw_remainder;

            result = {corr_remainder, corr_quotient};
        end else begin
            result = 16'd0;
        end
    end

endmodule