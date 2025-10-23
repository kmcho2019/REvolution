module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;           // Wait for '1'
            S1:   next_state = data_in ? S1 : S2;             // After '1', expect '0'
            S2:   next_state = data_in ? S1 : S3;             // After '10', expect '0' or restart if '1'
            S3:   next_state = data_in ? S1 : IDLE;           // After '100', expect '1' to detect '1001'
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

    // Output logic: sequence_detected asserted when current state is S3 and input is '1' (detecting "1001")
    assign sequence_detected = (state == S3) && data_in;

endmodule