module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

// Current and next states
state_t current_state, next_state;

// Always block for sequential logic
always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset to IDLE state
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        // Update current state
        current_state <= next_state;
        // Update sequence_detected output
        if (current_state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

// Always block for combinational logic
always @ (*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                // Transition to S1 on '1' input
                next_state = S1;
            end else begin
                // Stay in IDLE on '0' input
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                // Transition to S2 on '0' input
                next_state = S2;
            end else begin
                // Stay in S1 on '1' input
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                // Transition to S3 on '0' input
                next_state = S3;
            end else begin
                // Reset to IDLE on '1' input
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                // Transition to S4 on '1' input
                next_state = S4;
            end else begin
                // Reset to IDLE on '0' input
                next_state = IDLE;
            end
        end
        S4: begin
            // Reset to IDLE after detection
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule