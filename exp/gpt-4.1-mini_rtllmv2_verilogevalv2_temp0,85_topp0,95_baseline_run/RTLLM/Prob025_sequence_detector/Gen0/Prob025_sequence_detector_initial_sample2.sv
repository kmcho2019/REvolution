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
                    next_state = S1;  // first bit detected
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;  // second bit detected
                else
                    next_state = S1;  // stay in S1 if input is 1 (since first bit is 1)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;  // third bit detected
                else if (data_in == 1'b1)
                    next_state = S1;  // restart sequence detection (first bit detected)
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;  // fourth bit detected (sequence complete)
                else if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detecting full sequence, check if new input is 1 to continue detecting overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State update and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state     <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule