module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // synchronous active low reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding: represent how many bits matched so far in "1001"
    typedef enum logic [2:0] {
        IDLE = 3'd0,  // no bits matched
        S1   = 3'd1,  // matched '1'
        S10  = 3'd2,  // matched '10'
        S100 = 3'd3,  // matched '100'
        S1001= 3'd4   // matched '1001' (detect output here)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)         next_state = S1;
                else                 next_state = IDLE;
            end
            S1: begin
                if (!data_in)        next_state = S10;  // matched "10"
                else                 next_state = S1;   // still '1', start again
            end
            S10: begin
                if (!data_in)        next_state = IDLE; // expected '0' but got 0 then next bit must be '0' again to continue matching?
                else                 next_state = S100; // matched "100"
            end
            S100: begin
                if (data_in)         next_state = S1;   // matched final '1' of sequence, so next is matched '1' for possible overlap
                else                 next_state = S10;  // fallback to partial match "10"
            end
            default: next_state = IDLE;
        endcase
    end

    // State update with synchronous active low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Mealy output logic: sequence detected when the input bit completes the sequence in state S100
    assign sequence_detected = (state == S100) && data_in;

endmodule