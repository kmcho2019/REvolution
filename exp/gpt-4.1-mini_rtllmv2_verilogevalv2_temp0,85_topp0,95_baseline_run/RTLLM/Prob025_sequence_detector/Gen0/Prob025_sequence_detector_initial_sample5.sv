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

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
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
                    next_state = S1; // remain if input is 1, looking for 0 next
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else // data_in == 1
                    next_state = S3;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // sequence complete
                else if (data_in == 1'b0)
                    next_state = S2; // partial overlap for next seq
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, consider overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output sequential logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule