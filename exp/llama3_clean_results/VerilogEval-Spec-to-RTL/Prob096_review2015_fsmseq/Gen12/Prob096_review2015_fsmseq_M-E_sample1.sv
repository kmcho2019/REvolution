module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states for the FSM
typedef enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    SEEN_1101
} state_t;

state_t current_state, next_state;

// FSM state transition logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    next_state <= SEEN_1;
                end else begin
                    next_state <= IDLE;
                end
            end
            SEEN_1: begin
                if (data) begin
                    next_state <= SEEN_11;
                end else begin
                    next_state <= SEEN_1;
                end
            end
            SEEN_11: begin
                if (!data) begin
                    next_state <= SEEN_110;
                end else begin
                    next_state <= SEEN_11;
                end
            end
            SEEN_110: begin
                if (data) begin
                    next_state <= SEEN_1101;
                end else begin
                    next_state <= IDLE;
                end
            end
            SEEN_1101: begin
                next_state <= SEEN_1101;
            end
        endcase
        current_state <= next_state;
        if (current_state == SEEN_1101 && !start_shifting) begin
            start_shifting <= 1;
        end
    end
end

endmodule