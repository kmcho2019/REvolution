module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,  // No bits matched
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001' - detection state
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = data_in ? S1 : IDLE;
            S1:     next_state = data_in ? S1 : S2;
            S2:     next_state = data_in ? S3 : IDLE;
            S3:     next_state = data_in ? S4 : S2;
            S4:     next_state = data_in ? S1 : S2;  // Allow overlapping detection
            default:next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected is high only in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule