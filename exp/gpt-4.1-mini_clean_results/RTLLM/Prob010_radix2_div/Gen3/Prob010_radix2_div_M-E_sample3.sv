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
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    // Registers for internal values
    reg dividend_neg, divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg [8:0] remainder;   // 9-bit remainder register (extra bit for subtraction)
    reg [7:0] quotient;    // quotient register

    reg [3:0] count;       // iteration counter 0..7

    reg [8:0] sub_result;  // combinational subtraction result
    wire sub_nonneg = ~sub_result[8];

    // Combinational subtraction logic
    always @(*) begin
        // subtraction: remainder - divisor_abs (extended to 9 bits)
        sub_result = remainder - {1'b0, divisor_abs};
    end

    // Abs function for 8-bit signed numbers
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7]) abs8 = (~val) + 1'b1;
            else abs8 = val;
        end
    endfunction

    // FSM sequential and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            dividend_abs <= 8'b0;
            divisor_abs  <= 8'b0;
            remainder    <= 9'b0;
            quotient     <= 8'b0;
            count        <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture and prepare operands
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);
                        dividend_neg <= sign ? dividend[7] : 1'b0;
                        divisor_neg  <= sign ? divisor[7]  : 1'b0;

                        quotient_neg <= (sign ? (dividend[7] ^ divisor[7]) : 1'b0);
                        remainder_neg<= (sign ? dividend[7] : 1'b0);

                        remainder <= 9'b0;     // Initialize remainder 0
                        quotient  <= 8'b0;     // Initialize quotient 0
                        count     <= 4'd0;
                    end
                end

                DIVIDE: begin
                    // Shift remainder left by 1 and bring in next quotient bit at LSB (initially zero)
                    remainder <= {remainder[7:0], quotient[7]};

                    // Shift quotient left by 1
                    quotient <= {quotient[6:0], 1'b0};

                    // Perform subtraction only if divisor_abs != 0 (no divide by zero)
                    if (divisor_abs != 8'd0) begin
                        if (sub_nonneg) begin
                            // If remainder - divisor_abs >= 0, update remainder and set quotient LSB = 1
                            remainder <= sub_result;
                            quotient <= {quotient[6:0], 1'b1};
                        end
                    end
                    // else divide by zero: remainder and quotient remain zero

                    count <= count + 4'd1;
                end

                DONE: begin
                    // Adjust signs for quotient and remainder if signed operation
                    // Note: remainder is 9 bits but output only 8 bits (use lower 8 bits)
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    final_quotient = quotient;
                    final_remainder = remainder[7:0];

                    if (sign) begin
                        if (quotient_neg)
                            final_quotient = (~quotient + 8'd1);
                        if (remainder_neg)
                            final_remainder = (~final_remainder + 8'd1);
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end

                default: ;
            endcase
        end
    end

    // Next state logic
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
                if (opn_valid) // new operation requested
                    next_state = DIVIDE;
                else if (res_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule