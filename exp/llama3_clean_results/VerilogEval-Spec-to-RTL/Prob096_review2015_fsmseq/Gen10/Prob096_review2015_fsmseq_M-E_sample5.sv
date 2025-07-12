module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Enumerate states for sequence detection
enum logic [1:0] {
    IDLE,
    DETECTED_1,
    DETECTED_11,
    DETECTED_110,
    DETECTED_1101
} state, next_state;

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data) begin
                    next_state <= DETECTED_1;
                end else begin
                    next_state <= IDLE;
                end
            end
            DETECTED_1: begin
                if (data) begin
                    next_state <= DETECTED_11;
                end else begin
                    next_state <= IDLE;
                end
            end
            DETECTED_11: begin
                if (!data) begin
                    next_state <= DETECTED_110;
                end else begin
                    next_state <= DETECTED_1;
                end
            end
            DETECTED_110: begin
                if (data) begin
                    next_state <= DETECTED_1101;
                end else begin
                    next_state <= IDLE;
                end
            end
            DETECTED_1101: begin
                if (!reset) begin
                    start_shifting <= 1;
                    next_state <= DETECTED_1101; // Stay in this state
                end else begin
                    next_state <= IDLE;
                    start_shifting <= 0;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

endmodule