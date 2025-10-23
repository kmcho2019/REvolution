module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // Define states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,
        S2   = 2'b10,
        S3   = 2'b11
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition and output logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // Output is high only when in S3 and input is 1
            sequence_detected <= (current_state == S3) && (data_in == 1'b1);
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = (data_in == 1'b1) ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

endmodule