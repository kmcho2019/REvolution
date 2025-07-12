module sequence_detector (
    input  wire clk,
    input  wire reset_n,    // synchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    typedef enum logic [2:0] {
        IDLE  = 3'd0, // no match yet
        S1    = 3'd1, // matched '1'
        S10   = 3'd2, // matched "10"
        S100  = 3'd3, // matched "100"
        S1001 = 3'd4  // matched "1001" (final)
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            IDLE:       next_state = data_in ? S1    : IDLE;
            S1:         next_state = data_in ? S1    : S10;
            S10:        next_state = data_in ? S1    : S100;
            S100:       next_state = data_in ? S1001 : IDLE;
            S1001:      next_state = data_in ? S1    : IDLE;
            default:    next_state = IDLE;
        endcase
    end

    // Output logic - pulse high when next state is S1001 (sequence detected)
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (next_state == S1001);
    end

endmodule