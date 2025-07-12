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

    // State definition
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Registers to hold latched inputs and sign info
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit shift register: [partial_remainder(9 bits):quotient(8 bits)]
    reg [16:0] shift_reg;

    // Iteration counter (0 to 8)
    reg [3:0] count;

    // Combinational subtraction signals
    wire signed [8:0] partial_remainder = shift_reg[16:8];
    wire [7:0] quotient = shift_reg[7:0];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};

    wire signed [9:0] trial_sub = {partial_remainder[8], partial_remainder} - {1'b0, divisor_ext};
    wire quotient_bit = ~trial_sub[9]; // 1 if trial_sub >= 0

    wire [8:0] next_partial_remainder = quotient_bit ? trial_sub[8:0] : {partial_remainder[7:0], 1'b0};
    wire [7:0] next_quotient = {quotient[6:0], quotient_bit};

    // Function for absolute value conversion
    function [7:0] abs_val(input [7:0] val);
        abs_val = val[7] ? (~val + 1) : val;
    endfunction

    // Sign correction for output
    function [7:0] sign_correction(input [7:0] val, input sign_flag);
        sign_correction = sign_flag ? (~val + 1) : val;
    endfunction

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (res_valid && !opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential block for FSM and data path
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            count <= 4'd0;
            shift_reg <= 17'd0;

            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;

            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;

                    if (opn_valid) begin
                        // Latch sign info and compute absolute values
                        dividend_sign <= sign & dividend[7];
                        divisor_sign <= sign & divisor[7];

                        dividend_abs <= abs_val(dividend);
                        divisor_abs <= abs_val(divisor);

                        quotient_sign <= (sign & (dividend[7] ^ divisor[7]));
                        remainder_sign <= (sign & dividend[7]);

                        // Initialize shift register: remainder = dividend_abs shifted left 1, quotient=0
                        // remainder has 9 bits, so shift left one (multiply by 2)
                        shift_reg <= {dividend_abs, 1'b0, 8'd0};
                    end
                end

                DIVIDE: begin
                    // Increment iteration count
                    count <= count + 1;

                    // Update shift register with new remainder and quotient
                    shift_reg <= {next_partial_remainder, next_quotient};
                end

                DONE: begin
                    res_valid <= 1'b1;

                    // Apply sign correction to quotient and remainder
                    // quotient: lower 8 bits
                    // remainder: upper 9 bits, but output only 8 bits, so take bits [16:9]
                    // remainder is truncated to 8 bits
                    // For signed remainder, it's conventional to keep remainder sign same as dividend

                    reg [7:0] quotient_out;
                    reg [7:0] remainder_out;

                    quotient_out = sign_correction(shift_reg[7:0], quotient_sign);

                    remainder_out = sign_correction(shift_reg[16:9], remainder_sign);

                    result <= {remainder_out, quotient_out};
                end

                default: begin
                    // No operation
                end
            endcase
        end
    end

endmodule