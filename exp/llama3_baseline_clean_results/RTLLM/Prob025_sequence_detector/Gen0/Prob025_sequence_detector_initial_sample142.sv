module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize the current state
state_t current_state;
state_t next_state;

// FSM logic
always @(*) begin
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
            sequence_detected = 1'b1;
        end
        default: next_state = IDLE;
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (next_state != S4)
            sequence_detected <= 1'b0;
    end
end

endmodule