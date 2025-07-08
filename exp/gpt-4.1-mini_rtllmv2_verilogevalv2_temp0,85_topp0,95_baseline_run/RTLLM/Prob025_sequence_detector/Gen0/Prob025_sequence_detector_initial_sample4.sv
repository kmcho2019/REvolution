module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

// State encoding
typedef enum reg [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic and output logic
always @(*) begin
    // Default assignments
    next_state = IDLE;
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
            else
                next_state = S1; // remain in S1 if input is 1 (sequence restart)
        end

        S2: begin
            if (data_in == 0)
                next_state = IDLE; // sequence broken, restart
            else
                next_state = S3;
        end

        S3: begin
            if (data_in == 1'b)
                next_state = S4;
            else
                next_state = S2; // partial overlap, restart from S2 if 0
        end

        S4: begin
            sequence_detected = 1'b1;
            // For overlapping sequences, if next input is 1, go to S1, else IDLE
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase
end

endmodule