module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (binary encoded FSM)
    always @(*) begin
        case (state)
            IDLE:   next_state = data_in ? S1   : IDLE;
            S1:     next_state = (data_in == 1'b0) ? S2 : S1;
            S2:     next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:     next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:     next_state = data_in ? S1 : IDLE; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected for one clock cycle when entering S4
    // sequence_detected is high only when current state is S3 and input bit is '1'
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule