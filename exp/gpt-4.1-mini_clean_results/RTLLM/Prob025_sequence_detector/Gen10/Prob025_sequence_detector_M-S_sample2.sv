module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // matched '1'
        S2   = 3'd2, // matched '10'
        S3   = 3'd3, // matched '100'
        S4   = 3'd4  // matched '1001' (final state)
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1; // stay in S1 if data_in==1 to catch overlapping
            S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:   next_state = (data_in == 1'b1) ? S4 : S2; // if '0', go back to S2 (matched '10')
            S4:   next_state = (data_in == 1'b1) ? S1 : S2; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // State update and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule