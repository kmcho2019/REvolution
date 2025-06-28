module TopModule (
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

// Define states for the state machine
typedef enum logic [3:0] {
    STATE_IDLE,
    STATE_DETECT_PATTERN,
    STATE_SHIFT_BITS,
    STATE_WAIT_COUNTERS,
    STATE_NOTIFY_USER,
    STATE_WAIT_ACK
} state_type;

// Registers for state machine
reg [3:0] state, next_state;

// State machine logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= STATE_IDLE;
    end else begin
        state <= next_state;
    end
end

// Default next state and outputs
always @* begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;

    // State transitions and outputs
    case (state)
        STATE_IDLE:
            if (data == 4'b1101) begin
                next_state = STATE_DETECT_PATTERN;
            end
        STATE_DETECT_PATTERN:
            shift_ena = 1;
            next_state = STATE_SHIFT_BITS;
        STATE_SHIFT_BITS:
            counting = 1; // Add logic to shift in 4 bits
            next_state = STATE_WAIT_COUNTERS;
        STATE_WAIT_COUNTERS:
            if (done_counting) begin
                next_state = STATE_NOTIFY_USER;
            end
        STATE_NOTIFY_USER:
            done = 1;
            next_state = STATE_WAIT_ACK;
        STATE_WAIT_ACK:
            if (ack) begin
                next_state = STATE_IDLE;
            end
        default:
            next_state = STATE_IDLE;
    endcase
end

endmodule