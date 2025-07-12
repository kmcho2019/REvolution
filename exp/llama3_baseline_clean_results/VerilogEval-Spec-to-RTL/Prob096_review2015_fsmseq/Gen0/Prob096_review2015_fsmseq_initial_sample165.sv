module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

enum logic [2:0] {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    SEEN_1101
} state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == SEEN_1101) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data) begin
                next_state = SEEN_1;
            end
        end
        SEEN_1: begin
            if (data) begin
                next_state = SEEN_11;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_11: begin
            if (~data) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_11;
            end
        end
        SEEN_110: begin
            if (data) begin
                next_state = SEEN_1101;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1101: begin
            next_state = SEEN_1101; // Stay in this state until reset
        end
        default: next_state = IDLE;
    endcase
end

endmodule