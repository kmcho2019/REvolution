module sequence_detector (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    output reg sequence_detected
);

// State encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state and output logic
always @(*) begin
    sequence_detected = 1'b0;
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
            else if (data_in == 1'b1)
                next_state = S1; // stay in S1 if input 1 (possible overlapping sequence)
            else
                next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S3;
            else if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
                sequence_detected = 1'b1;
            end
            else if (data_in == 1'b0)
                next_state = IDLE;
            else
                next_state = IDLE;
        end
        S4: begin
            // After detecting full sequence, check next input for overlapping sequences
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
            sequence_detected = 1'b1;
        end
        default: begin
            next_state = IDLE;
            sequence_detected = 1'b0;
        end
    endcase
end

endmodule