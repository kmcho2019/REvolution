module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enum for states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_type;

// Current state and next state
state_type current_state, next_state;

// Sequence detection logic
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
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data_in == 1) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (data_in == 1) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = S1;
                sequence_detected = 1'b0;
            end
        end
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule