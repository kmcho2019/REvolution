module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Assign the output sequence_detected based on the current state
always_comb begin
    case (state)
        IDLE: sequence_detected = 1'b0;
        S1: sequence_detected = 1'b0;
        S2: sequence_detected = 1'b0;
        S3: sequence_detected = 1'b0;
        S4: sequence_detected = 1'b1;
        default: sequence_detected = 1'b0;
    endcase
end

// Define the next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0) next_state = S3;
            else next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update the current state on each clock cycle
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) state <= IDLE;
    else state <= next_state;
end

endmodule