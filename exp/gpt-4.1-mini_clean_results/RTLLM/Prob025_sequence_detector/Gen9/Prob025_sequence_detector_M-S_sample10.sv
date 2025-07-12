module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoding of states
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE:  next_state = (data_in) ? S1 : IDLE;
            S1:    next_state = (!data_in) ? S2 : S1;
            S2:    next_state = (!data_in) ? S3 : IDLE;
            S3:    next_state = (data_in) ? S4 : IDLE;
            S4:    next_state = (data_in) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: Assert sequence_detected for one cycle when in S4
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule