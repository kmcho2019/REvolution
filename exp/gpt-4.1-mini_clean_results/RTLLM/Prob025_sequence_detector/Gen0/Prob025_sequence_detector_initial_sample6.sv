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
                    next_state = S1; // Stay in S1 if input is 1 again (since sequence starts with 1)
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else if (data_in == 1'b1)
                    next_state = S3;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S1;  // restart because this bit can be start of new sequence
                else if (data_in == 1'b0)
                    next_state = S2;  // partial match could be restarted here
                else
                    next_state = S4;
            end

            S4: begin
                // After detection, check next input bit for possible overlapping detection
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

    // Output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S3) && (data_in == 1'b1); 
            // sequence 1001 detected when in S3 and input is 1 (4th bit)
    end

endmodule