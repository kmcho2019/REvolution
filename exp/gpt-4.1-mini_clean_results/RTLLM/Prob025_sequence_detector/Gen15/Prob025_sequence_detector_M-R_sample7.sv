module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary-encoded FSM states
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output: asserted when current state is S4
            sequence_detected <= (state == S4);
        end
    end

endmodule