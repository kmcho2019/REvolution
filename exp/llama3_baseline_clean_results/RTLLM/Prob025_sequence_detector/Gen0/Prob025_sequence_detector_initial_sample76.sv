module sequence_detector (
    input  clk,
    input  reset_n,
    input  data_in,
    output sequence_detected
);

// Define the states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Current state and next state
state_t current_state;
state_t next_state;

// Assign output
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// FSM state transition logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = IDLE;
            else if (data_in == 1'b0)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = IDLE;
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

// Sequential logic for state update
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule