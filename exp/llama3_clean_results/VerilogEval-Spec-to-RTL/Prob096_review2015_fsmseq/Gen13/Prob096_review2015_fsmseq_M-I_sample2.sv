module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states for the FSM
typedef enum logic [2:0] {
    IDLE = 3'd0,
    SEEN_1 = 3'd1,
    SEEN_11 = 3'd2,
    SEEN_110 = 3'd3,
    SEEN_1101 = 3'd4
} state_t;

state_t current_state;

// FSM state transition logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: current_state <= data ? SEEN_1 : IDLE;
            SEEN_1: current_state <= data ? SEEN_11 : IDLE;
            SEEN_11: current_state <= !data ? SEEN_110 : SEEN_1;
            SEEN_110: current_state <= data ? SEEN_1101 : IDLE;
            SEEN_1101: current_state <= SEEN_1101;
        endcase
        if (current_state == SEEN_1101 && !start_shifting) begin
            start_shifting <= 1;
        end
    end
end

endmodule