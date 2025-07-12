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

    // Internal registers
    reg busy;

    // Latched inputs
    reg dividend_sign;
    reg divisor_sign;
    reg quotient_sign;
    reg remainder_sign;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift register holds remainder and quotient:
    // remainder: 9 bits (upper), quotient: 8 bits (lower)
    reg [16:0] shift_reg;

    // Iteration counter: counts 0 to 7 (8 cycles)
    reg [3:0] count;

    // Combinational wires for subtraction
    wire signed [9:0] rem_extended = {shift_reg[16], shift_reg[16:8]}; // sign-extend remainder
    wire [8:0] divisor_extended = {1'b0, divisor_abs}; // divisor is positive, 9 bits
    wire signed [9:0] subtract_result = rem_extended - {1'b0, divisor_extended};

    // Signals for updating shift register
    wire subtract_nonneg = ~subtract_result[9]; // MSB=0 means result >= 0

    wire [8:0] next_remainder = subtract_nonneg ? subtract_result[8:0] : shift_reg[16:8];
    wire [7:0] next_quotient = {shift_reg[7:0], subtract_nonneg};

    // Functions for absolute value and sign correction
    function [7:0] abs_val(input [7:0] val);
        begin
            abs_val = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    function [7:0] sign_correct(input [7:0] val, input sign_flag);
        begin
            sign_correct = sign_flag ? (~val + 8'd1) : val;
        end
    endfunction

    // Control FSM: busy when division in progress
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 1'b0;
            res_valid <= 1'b0;
            count <= 4'd0;
            shift_reg <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
            result <= 16'd0;
        end else begin
            if (!busy) begin
                // Idle state - wait for start
                res_valid <= 1'b0;
                count <= 4'd0;
                if (opn_valid) begin
                    // Latch inputs and compute absolute values and signs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= abs_val(dividend);
                    divisor_abs <= abs_val(divisor);

                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];

                    // Initialize shift register:
                    // remainder = dividend_abs shifted left by 1 (to 9 bits)
                    // quotient = 0
                    shift_reg <= {dividend_abs, 1'b0, 8'd0};

                    busy <= 1'b1;
                end
            end else begin
                // Division in progress
                if (count == 4'd8) begin
                    // Division done
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign correction
                    // remainder: upper 9 bits of shift_reg => output only 8 bits by truncation [16:9]
                    // quotient: lower 8 bits [7:0]
                    result[7:0]   <= sign_correct(shift_reg[7:0], quotient_sign);
                    result[15:8]  <= sign_correct(shift_reg[16:9], remainder_sign);
                end else begin
                    // Perform one iteration
                    count <= count + 1'b1;

                    // Update remainder and quotient in shift_reg
                    // Shift left by 1: shift_reg[16:8] updated with next_remainder, lower 8 bits updated with next_quotient
                    shift_reg <= {next_remainder, next_quotient};
                end
            end
        end
    end

endmodule