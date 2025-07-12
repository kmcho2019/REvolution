module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // State encoding
    typedef enum {
        IDLE,
        S1,
        S2,
        S3,
        S4
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
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:   begin
                sequence_detected = 1'b1;
                next_state = (data_in == 1'b1) ? S1 : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule