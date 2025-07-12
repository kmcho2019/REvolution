module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output wire res_valid,
    output wire [15:0] result
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] cnt;
    reg [16:0] SR; // {remainder, quotient, temp_bit}
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;
    reg dividend_sign;
    reg divisor_sign;
    reg sign_reg;

    // Absolute value calculation
    wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
    wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

    // Negative divisor for subtraction
    wire [7:0] neg_divisor = -divisor_abs;

    // Intermediate subtraction result
    wire [8:0] sub_result = {1'b0, SR[16:9]} + {1'b0, neg_divisor};
    wire sub_ok = ~sub_result[8]; // No overflow means subtraction is valid

    // FSM transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = (opn_valid & ~res_valid) ? CALC : IDLE;
            CALC: next_state = (cnt == 4'd8) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'b0;
            SR <= 17'b0;
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            sign_reg <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (opn_valid & ~res_valid) begin
                        sign_reg <= sign;
                        dividend_sign <= sign & dividend[7];
                        divisor_sign <= sign & divisor[7];
                        dividend_abs <= abs_dividend;
                        divisor_abs <= abs_divisor;
                        SR <= {9'b0, abs_dividend, 1'b0};
                        cnt <= 4'b1;
                    end
                end

                CALC: begin
                    if (sub_ok) begin
                        SR <= {sub_result[7:0], SR[8:0], 1'b1};
                    end else begin
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end

                DONE: begin
                    // Apply sign correction if needed
                    if (sign_reg) begin
                        // Quotient sign
                        if (dividend_sign ^ divisor_sign) begin
                            SR[8:1] <= -SR[8:1];
                        end
                        // Remainder sign
                        if (dividend_sign) begin
                            SR[16:9] <= -SR[16:9];
                        end
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign res_valid = (state == DONE);
    assign result = {SR[16:9], SR[8:1]};

endmodule