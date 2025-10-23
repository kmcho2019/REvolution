module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,  // no match yet
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001' (final)
    } state_t;

    state_t state, next_state;

    // State transition on clock with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (data_in) ? S1 : IDLE;
            S1:    next_state = (data_in) ? S1 : S2;
            S2:    next_state = (data_in) ? S1 : S3;
            S3:    next_state = (data_in) ? S4 : IDLE;
            S4:    next_state = (data_in) ? S1 : S2;  // allow overlap detection
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected high only in S4
    always @(posedge clk) begin
        sequence_detected <= (state == S4);
    end

endmodule