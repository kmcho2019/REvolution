module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg        quotient_neg;
    reg        remainder_neg;

    reg [7:0] quotient;
    reg [8:0] remainder; // 9 bits for remainder: remainder can be up to 8 bits plus borrow bit

    reg [3:0] cnt;

    wire [8:0] sub_res = remainder - {1'b0, divisor_abs};
    wire       borrow = sub_res[8];

    // Compute absolute values inline
    wire [7:0] dividend_abs_in = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_in  = (sign && divisor[7])  ? (~divisor  + 1) : divisor;

    // Negate function for sign correction
    function [7:0] negate;
        input [7:0] val;
        begin
            negate = ~val + 1;
        end
    endfunction

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 0;
            result      <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            quotient    <= 8'd0;
            remainder   <= 9'd0;
            cnt         <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 0;
                    if (opn_valid) begin
                        dividend_abs <= dividend_abs_in;
                        divisor_abs  <= divisor_abs_in;
                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];
                        quotient    <= 8'd0;
                        remainder   <= {1'b0, dividend_abs_in}; // remainder = dividend_abs
                        cnt         <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 0) begin
                        // Division by zero: output zero immediately
                        quotient  <= 8'd0;
                        remainder <= 9'd0;
                        cnt       <= 4'd8; // force completion
                    end else if (cnt < 8) begin
                        if (!borrow) begin
                            // remainder >= divisor_abs, subtract and set quotient bit
                            remainder <= {sub_res[7:0], 1'b0};
                            quotient  <= {quotient[6:0], 1'b1};
                        end else begin
                            // remainder < divisor_abs, keep remainder and quotient bit=0
                            remainder <= {remainder[7:0], 1'b0};
                            quotient  <= {quotient[6:0], 1'b0};
                        end
                        cnt <= cnt + 1;
                    end
                end

                DONE: begin
                    // sign correction and output are handled in next_state logic
                    res_valid <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end

            DIVIDE: begin
                if (cnt == 8)
                    next_state = DONE;
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Result assembly and sign correction
    always @(posedge clk) begin
        if (state == DONE) begin
            // Extract quotient and remainder from registers
            reg [7:0] q = quotient;
            reg [7:0] r = remainder[8:1]; // upper 8 bits of remainder shifted right by 1, since remainder shifted left each cycle

            if (sign) begin
                if (quotient_neg)
                    q = negate(q);
                if (remainder_neg)
                    r = negate(r);
            end
            result <= {r, q};
        end
    end

endmodule