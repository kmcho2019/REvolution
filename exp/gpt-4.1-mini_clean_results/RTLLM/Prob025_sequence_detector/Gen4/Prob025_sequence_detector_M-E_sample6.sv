module sequence_detector (
    input  wire clk,
    input  wire reset,           // active high reset as per problem statement
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,  // no bits matched
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001' (full sequence)
    } state_t;

    state_t current_state, next_state;

    // Next state logic (combinational)
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
                else // data_in == 1
                    next_state = S1; // remain if '1' (start over)
            end
            S2: begin
                if (data_in == 0)
                    next_state = S3;
                else // data_in == 1
                    next_state = S1; // restart from S1 because last input is '1'
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // sequence detected
                else // data_in == 0
                    next_state = IDLE; // no partial match, reset
            end
            S4: begin
                // After detecting the sequence, consider overlap:
                // If input is '1', possible start of new sequence, else no match
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and output update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // sequence_detected asserted only in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

endmodule