module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE,
        S1,     // 1
        S2,     // 10
        S3,     // 100
        DETECT  // 1001
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        sequence_detected = 1'b0;
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S3 : IDLE;
            S3:   next_state = data_in ? DETECT : IDLE;
            DETECT: begin
                sequence_detected = 1'b1;
                next_state = data_in ? S1 : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule