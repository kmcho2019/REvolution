module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding using an enumerated type for clarity
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4    // Final detection state after 4 bits matched
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:   next_state = (data_in == 1'b1) ? S1 : S2; // allow overlapping detection
            default: next_state = IDLE;
        endcase
    end

    // Output logic is combinational: asserted only in S4 state
    assign sequence_detected = (state == S4);

endmodule