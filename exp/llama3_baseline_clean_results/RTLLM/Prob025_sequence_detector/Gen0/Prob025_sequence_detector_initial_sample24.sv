module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states for the finite state machine
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t current_state;
state_t next_state;

// Assign the sequence_detected signal based on the current state
always @(posedge clk) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

// Define the next state based on the current state and input data_in
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule