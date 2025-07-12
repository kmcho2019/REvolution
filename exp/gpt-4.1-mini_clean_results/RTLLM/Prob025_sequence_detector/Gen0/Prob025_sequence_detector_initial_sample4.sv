module sequence_detector (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    output reg sequence_detected
);

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
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // If input is 1 again, stay in S1 (sequence start)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = S3;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = S1; // Because last 1 can start new sequence
            end
            S4: begin
                // After detection, check input for possible overlapping sequence
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset (reset_n active low)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic: sequence_detected asserted when in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule