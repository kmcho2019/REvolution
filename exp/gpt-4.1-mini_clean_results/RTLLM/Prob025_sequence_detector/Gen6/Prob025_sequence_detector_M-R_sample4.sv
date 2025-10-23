module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary state encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        DETECT = 3'd4
    } state_t;

    state_t state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE:   next_state = data_in ? S1 : IDLE;                  // Wait for '1'
            S1:     next_state = data_in ? S1 : S2;                    // '10' detected
            S2:     next_state = data_in ? S3 : IDLE;                  // '100' detected
            S3:     next_state = data_in ? DETECT : S2;                // '1001' detected -> DETECT
            DETECT: next_state = data_in ? S1 : IDLE;                  // Allow overlapping detection
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic - Moore FSM: assert sequence_detected only in DETECT state
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == DETECT);
    end

endmodule