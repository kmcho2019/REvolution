module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // detected '1'
        S2   = 3'd2, // detected '10'
        S3   = 3'd3, // detected '100'
        S4   = 3'd4  // detected '1001' (final)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        // Default next state is current state
        next_state = current_state;
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
                    next_state = S1; // stay in S1 if input is 1 (sequence starts with 1)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart from S1 if input is 1
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S4;
                end else begin
                    next_state = IDLE;
                end
            end
            S4: begin
                // Sequence detected, output sequence_detected = 1 here
                sequence_detected = 1'b1;
                // After detecting 1001, check if last bit is 1 to handle overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register update with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

endmodule