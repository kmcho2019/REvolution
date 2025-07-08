module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001, // Detected '1'
        S2   = 3'b010, // Detected '10'
        S3   = 3'b011, // Detected '100'
        S4   = 3'b100  // Detected '1001' (final)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        // Default next state is current state
        next_state = current_state;
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
                    next_state = S1; // Stay if '1' again (allow overlapping)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else if (data_in == 1'b1)
                    next_state = S1; // restart sequence with new '1'
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // sequence detected
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, check for next possible sequence start
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // sequence_detected is high only when current_state transitions to S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule