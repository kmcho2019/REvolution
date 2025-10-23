module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam RUN    = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    // Internal registers
    reg start_div;            // indicates division start
    reg [3:0] cnt;            // counter for 8 iterations (0-8)
    reg [16:0] SR;            // Shift register: [16:8] remainder (9 bits), [7:0] quotient
    reg [16:0] sub_res;       // subtraction result

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg [8:0] neg_divisor;    // negative divisor extended to 9 bits

    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    // Helper functions for abs and negation
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7]) abs8 = (~val) + 8'd1;
            else abs8 = val;
        end
    endfunction

    // Two's complement for 8 bits
    function [7:0] twos_comp8;
        input [7:0] val;
        begin
            twos_comp8 = (~val) + 8'd1;
        end
    endfunction

    // Two's complement for 9 bits
    function [8:0] twos_comp9;
        input [8:0] val;
        begin
            twos_comp9 = (~val) + 9'd1;
        end
    endfunction

    // Combinational subtraction: remainder[16:8] - divisor_abs
    always @(*) begin
        // remainder part is 9 bits: SR[16:8]
        // divisor_abs zero-extended to 9 bits
        sub_res = {1'b0, SR[16:8]} + neg_divisor;  // addition with negative divisor
    end

    // FSM sequential and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            SR           <= 17'd0;
            cnt          <= 4'd0;

            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            neg_divisor  <= 9'd0;

            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;

            start_div    <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Calculate absolute values and signs if signed division
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        dividend_neg <= sign ? dividend[7] : 1'b0;
                        divisor_neg  <= sign ? divisor[7]  : 1'b0;

                        quotient_neg <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg<= sign ? dividend[7] : 1'b0;

                        // NEG_DIVISOR = -divisor_abs (9 bits)
                        neg_divisor <= twos_comp9({1'b0, abs8(divisor)});

                        // Initialize shift register:
                        // remainder (9 bits) = dividend_abs shifted left 1 bit: {dividend_abs, 1'b0}
                        // quotient (8 bits) = 0
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        cnt <= 4'd0;
                        start_div <= 1'b1;
                    end else begin
                        start_div <= 1'b0;
                    end
                end

                RUN: begin
                    start_div <= 1'b0;

                    // If divisor is zero, produce zero quotient and remainder immediately
                    if (divisor_abs == 8'd0) begin
                        // Stall here, count to 8 cycles then finish with zero result
                        if (cnt < 4'd8) begin
                            cnt <= cnt + 4'd1;
                            // SR remains unchanged (zero quotient, remainder)
                        end
                    end else begin
                        // Perform subtraction: SR[16:8] + NEG_DIVISOR = sub_res
                        if (~sub_res[16]) begin
                            // sub_res positive or zero => update SR with sub_res in remainder bits, shift quotient in
                            // Shift SR left by 1, insert 1 in quotient LSB
                            SR <= {sub_res[15:7], SR[7:1], 1'b1};
                        end else begin
                            // subtraction negative => shift SR left by 1, insert 0 in quotient LSB
                            SR <= {SR[15:0], 1'b0};
                        end

                        cnt <= cnt + 4'd1;
                    end
                end

                DONE: begin
                    // Sign adjust quotient and remainder if signed

                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    final_quotient = SR[7:0];
                    final_remainder = SR[16:9];

                    if (sign) begin
                        if (quotient_neg)
                            final_quotient = twos_comp8(final_quotient);
                        if (remainder_neg)
                            final_remainder = twos_comp8(final_remainder);
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end

            RUN: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end

            DONE: begin
                if (res_valid && !opn_valid)
                    next_state = IDLE;
                else if (opn_valid)
                    next_state = RUN;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule