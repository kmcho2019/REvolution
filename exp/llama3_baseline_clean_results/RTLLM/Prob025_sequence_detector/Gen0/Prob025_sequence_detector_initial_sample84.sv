module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_type;

// Current and next state
state_type current_state;
state_type next_state;

// Sequence detected signal
reg sequence_detected;

// Sequential logic for state machine
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

// Combinational logic for next state
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (data_in == 1) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule