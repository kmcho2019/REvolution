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

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_sign, divisor_sign, quotient_sign, remainder_sign;

    reg [16:0] SR;       // SR[16:8]: remainder (9 bits), SR[7:0]: quotient (8 bits)
    reg [3:0]  count;

    wire [8:0] remainder = SR[16:8];
    wire [8:0] sub_result = remainder - {1'b0, divisor_abs};
    wire       sub_nonneg = ~sub_result[8]; // 1 if >=0

    // Absolute value helper
    function [7:0] abs_val;
        input [7:0] val;
        begin
            abs_val = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Sign correction helper
    function [7:0] neg_val;
        input [7:0] val;
        begin
            neg_val = ~val + 8'd1;
        end
    endfunction

    // FSM sequential
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
            SR            <= 17'd0;
            count         <= 4'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_sign <= (sign) ? dividend[7] : 1'b0;
                        divisor_sign  <= (sign) ? divisor[7] : 1'b0;
                        quotient_sign <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= (sign) ? dividend[7] : 1'b0;
                        dividend_abs  <= abs_val(dividend);
                        divisor_abs   <= abs_val(divisor);
                        // Initialize SR: remainder = dividend_abs shifted left by 1 bit (9 bits), quotient=0
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        count <= 4'd0;
                    end
                end
                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: quotient and remainder zero, finish immediately
                        SR <= 17'd0;
                        count <= 4'd8;
                    end else if (sub_nonneg) begin
                        // remainder - divisor_abs >= 0: update remainder and set quotient bit = 1
                        SR <= {sub_result[7:0], SR[7:0], 1'b1};
                        count <= count + 1;
                    end else begin
                        // remainder < divisor_abs: shift left, quotient bit = 0
                        SR <= {SR[15:0], 1'b0};
                        count <= count + 1;
                    end
                end
                DONE: begin
                    if (~res_valid) begin
                        // Output result with sign correction
                        reg [7:0] q, r;
                        q = SR[7:0];
                        r = SR[16:9];  // Upper 8 bits of remainder (discard LSB shifted in at start)
                        if (sign) begin
                            if (quotient_sign) q = neg_val(q);
                            if (remainder_sign) r = neg_val(r);
                        end
                        result    <= {r, q};
                        res_valid <= 1'b1;
                    end else if (~opn_valid) begin
                        res_valid <= 1'b0; // wait for next opn_valid to start new division
                    end
                end
            endcase
        end
    end

    // FSM combinational next state
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (res_valid && ~opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule