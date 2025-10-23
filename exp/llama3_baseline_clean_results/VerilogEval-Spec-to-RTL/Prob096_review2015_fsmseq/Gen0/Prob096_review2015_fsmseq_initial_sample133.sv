module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enumerate states for sequence detection
typedef enum logic [2:0] {
    IDLE,     // Initial state
    SEEN_1,   // Seen first '1'
    SEEN_11,  // Seen '11'
    SEEN_110, // Seen '110'
    SEEN_1101 // Seen '1101'
} state_t;

state_t current_state, next_state;

// Default output
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end
end

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (data) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
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
            if (data) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1101;
            end
        end
        SEEN_1101: begin
            next_state = SEEN_1101;
        end
        default: next_state = IDLE;
    endcase
end

// Set start_shifting when the sequence is detected
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end else if (current_state == SEEN_1101) begin
        start_shifting <= 1;
    end
end

endmodule