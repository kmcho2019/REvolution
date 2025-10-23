module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Define states as an enumeration
enum logic [1:0] {
    IDLE,
    INIT,
    DIVIDE,
    DONE
} state, next_state;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: next_state = (opn_valid &&!res_valid)? INIT : IDLE;
        INIT: next_state = DIVIDE;
        DIVIDE: next_state = (cnt == 8)? DONE : DIVIDE;
        DONE: next_state = (opn_valid)? INIT : IDLE;
    endcase
end

// Combinational logic for updated values
always @(*) begin
    case(state)
        IDLE: begin
            if (opn_valid &&!res_valid) begin
                dividend_reg = sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                divisor_reg = sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                shift_reg = {8'b0, dividend_reg};
                cnt = 1;
                start_cnt = 1;
            end else begin
                dividend_reg = dividend_reg;
                divisor_reg = divisor_reg;
                shift_reg = shift_reg;
                cnt = cnt;
                start_cnt = start_cnt;
            end
        end
        INIT: begin
            dividend_reg = dividend_reg;
            divisor_reg = divisor_reg;
            shift_reg = shift_reg;
            cnt = cnt;
            start_cnt = start_cnt;
        end
        DIVIDE: begin
            if (shift_reg[15:8] >= divisor_reg) begin
                shift_reg = {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg = {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
            cnt = cnt + 1;
        end
        DONE: begin
            result = {shift_reg[15:8], shift_reg[7:0]};
            res_valid = 1;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        state <= next_state;
        res_valid <= (state == DONE)? 1'b1 : (opn_valid && state!= DONE)? res_valid : 1'b0;
        if (state == DONE) begin
            result <= {shift_reg[15:8], shift_reg[7:0]};
        end else begin
            result <= result;
        end
        dividend_reg <= (state == IDLE && opn_valid &&!res_valid)? (sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend}) : dividend_reg;
        divisor_reg <= (state == IDLE && opn_valid &&!res_valid)? (sign? {{7{divisor[7]}}, divisor[7:0]} : divisor) : divisor_reg;
        shift_reg <= (state == DIVIDE)? (shift_reg[15:8] >= divisor_reg? {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]} : {shift_reg[15:8], 1'b0, shift_reg[7:1]}) : shift_reg;
        cnt <= (state == DIVIDE)? cnt + 1 : (state == IDLE && opn_valid &&!res_valid)? 1 : cnt;
        start_cnt <= (state == IDLE && opn_valid &&!res_valid)? 1 : start_cnt;
    end
end

endmodule