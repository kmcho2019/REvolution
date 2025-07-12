module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    parameter IDLE   = 3'd0;
    parameter S1     = 3'd1;
    parameter S10    = 3'd2;
    parameter S100   = 3'd3;
    parameter S1001  = 3'd4;

    reg [2:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;     // '1' detected
                else
                    next_state = IDLE;   // stay idle
            end
            S1: begin
                if (!data_in)
                    next_state = S10;    // matched '10'
                else
                    next_state = S1;     // stay in S1, multiple '1's
            end
            S10: begin
                if (!data_in)
                    next_state = S100;   // matched '100'
                else
                    next_state = S1;     // bit=1, possible new sequence start
            end
            S100: begin
                if (data_in)
                    next_state = S1001;  // matched full "1001"
                else
                    next_state = IDLE;   // mismatch, go to idle
            end
            S1001: begin
                // After detection, handle overlap:
                // input bit may start new sequence if 1, else idle
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore FSM): asserted only in S1001 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S1001);
    end

endmodule