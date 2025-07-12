module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        S4
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Output is high only when in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:   next_state = (data_in == 1'b1) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule