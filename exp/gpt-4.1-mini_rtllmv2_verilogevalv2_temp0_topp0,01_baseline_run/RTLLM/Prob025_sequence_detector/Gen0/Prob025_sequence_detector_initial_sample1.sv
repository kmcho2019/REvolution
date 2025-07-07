module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
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
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;  // first bit '1' detected
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;  // second bit '0' detected
                else
                    next_state = S1;  // stay in S1 if input is '1' (overlapping sequences)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;  // third bit '0' detected
                else
                    next_state = S1;  // input '1' means restart from S1 (sequence 1)
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;  // fourth bit '1' detected, sequence complete
                else
                    next_state = IDLE; // input '0' breaks sequence, go to IDLE
            end
            S4: begin
                // After detection, check if next input can start a new sequence
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic (Moore machine)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule