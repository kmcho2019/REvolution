module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
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
                else // input 1, restart from S1 (sequence starts with 1)
                    next_state = S1;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else // input 1, restart from S1
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else // input 0, restart from IDLE
                    next_state = IDLE;
            end

            S4: begin
                // After detecting the sequence, decide next state based on input
                // This allows overlapping sequences detection
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // sequence_detected asserted only when FSM is in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

endmodule