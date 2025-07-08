module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // Define states
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t current_state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default values
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
                    next_state = S1; // Stay if input is 1 (still first bit detected)
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // sequence broken, restart
                else
                    next_state = S3; // bit 3 = 1
            end

            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S4;
                    sequence_detected = 1'b1;
                end else
                    next_state = S2; // if 0, sequence could overlap starting from second bit
            end

            S4: begin
                // After detecting the sequence, check for overlapping sequences
                sequence_detected = 1'b1;
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule