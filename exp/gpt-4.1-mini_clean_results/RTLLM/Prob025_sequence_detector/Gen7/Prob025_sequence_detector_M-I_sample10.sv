module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded states
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
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
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;

            S1:   next_state = (!data_in) ? S2 : S1;

            S2:   next_state = (!data_in) ? S3 : IDLE;

            S3:   next_state = data_in ? S4 : IDLE;

            S4:   next_state = data_in ? S1 : IDLE;

            default: next_state = IDLE;
        endcase
    end

    // Output logic: Assert sequence_detected for one clock cycle when entering S4
    // sequence_detected asserted when current state is S3 and data_in=1 (next_state = S4)
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule