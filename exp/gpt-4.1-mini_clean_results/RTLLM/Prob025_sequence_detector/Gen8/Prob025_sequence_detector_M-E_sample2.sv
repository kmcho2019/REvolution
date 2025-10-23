module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Asynchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary encoded for minimal flip-flops)
    typedef enum logic [2:0] {
        IDLE = 3'b000,    // No bits matched
        S1   = 3'b001,    // Matched '1'
        S2   = 3'b010,    // Matched '10'
        S3   = 3'b011,    // Matched '100'
        S4   = 3'b100     // Matched '1001' (final detection state)
    } state_t;

    state_t state, next_state;

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
            IDLE: 
                next_state = (data_in == 1'b1) ? S1 : IDLE;

            S1: 
                next_state = (data_in == 1'b0) ? S2 : S1;

            S2:
                next_state = (data_in == 1'b0) ? S3 : S1;

            S3:
                next_state = (data_in == 1'b1) ? S4 : IDLE;

            S4:
                // After detection, allow overlapping sequences starting from '1' or '0'
                next_state = (data_in == 1'b1) ? S1 : S2;

            default:
                next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted when in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule