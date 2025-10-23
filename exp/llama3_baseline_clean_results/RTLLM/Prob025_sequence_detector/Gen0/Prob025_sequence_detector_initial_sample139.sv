module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// FSM state transitions
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// FSM state update
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Sequence detection
always_comb begin
    if (current_state == S4)
        sequence_detected = 1'b1;
    else
        sequence_detected = 1'b0;
end

endmodule