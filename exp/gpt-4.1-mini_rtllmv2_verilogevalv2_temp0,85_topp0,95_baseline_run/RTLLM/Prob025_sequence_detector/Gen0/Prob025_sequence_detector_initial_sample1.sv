module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

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
                else
                    next_state = S1; // restart because sequence starts with 1
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
                    next_state = S2; // partial overlap: detected '100' then got 0, move to S2
            end

            S4: begin
                // After sequence detected, check if next input can start new sequence
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

    // Output logic: sequence_detected asserted only in S4 (Moore output)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule