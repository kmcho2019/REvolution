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

// Define states for the state machine
enum logic [1:0] {
    IDLE,
    DIVIDE,
    FINALIZE
} state, next_state;

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_div;

// Combinational logic for state transitions
always_comb begin
    case (state)
        IDLE: begin
            if (opn_valid && !res_valid) begin
                next_state = DIVIDE;
            end else begin
                next_state = IDLE;
            end
        end
        DIVIDE: begin
            if (cnt == 8) begin
                next_state = FINALIZE;
            end else begin
                next_state = DIVIDE;
            end
        end
        FINALIZE: begin
            next_state = IDLE;
        end
    endcase
end

// Combinational logic for calculating the next state and updating the division process
assign remainder = (state == IDLE && opn_valid && !res_valid) ? (sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend) : (state == DIVIDE && cnt < 8) ? (remainder >= neg_divisor ? remainder - neg_divisor : remainder) : remainder;
assign neg_divisor = (state == IDLE && opn_valid && !res_valid) ? (sign ? (~divisor + 1) : divisor) : neg_divisor;
assign start_div = (state == IDLE && opn_valid && !res_valid) ? 1'b1 : (state == FINALIZE) ? 1'b0 : start_div;
assign cnt = (state == IDLE && opn_valid && !res_valid) ? 3'd1 : (state == DIVIDE && cnt < 8) ? cnt + 1'd1 : (state == FINALIZE) ? 3'd0 : cnt;
assign quotient = (state == DIVIDE && cnt < 8 && remainder >= neg_divisor) ? quotient + (1 << (8 - cnt)) : quotient;

// Sequential logic for the state registers and division process
always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
    end else begin
        state <= next_state;
        if (state == FINALIZE) begin
            res_valid <= 1;
            result <= {remainder, quotient};
        end
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule