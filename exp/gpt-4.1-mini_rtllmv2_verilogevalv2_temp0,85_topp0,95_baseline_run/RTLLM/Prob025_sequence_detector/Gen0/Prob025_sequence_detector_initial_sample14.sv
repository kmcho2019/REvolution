module sequence_detector (
    input        clk,
    input        reset_n,
    input        data_in,
    output reg   sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // Detected '1'
        S2   = 3'd2, // Detected '10'
        S3   = 3'd3, // Detected '100'
        S4   = 3'd4  // Detected '1001'
    } state_t;

    state_t current_state, next_state;

    // State transition logic
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
                    next_state = S1; // Stay in S1 if '1' again (to handle overlapping sequences)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // Restart at S1 if '1'
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, check data_in to decide next state for overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // sequence_detected asserted only in S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule