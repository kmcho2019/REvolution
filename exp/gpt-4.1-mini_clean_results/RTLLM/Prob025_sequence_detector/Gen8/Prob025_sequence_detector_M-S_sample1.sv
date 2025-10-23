module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,   // matched '1'
        S2   = 3'd2,   // matched '10'
        S3   = 3'd3,   // matched '100'
        S4   = 3'd4    // matched '1001' (final detection)
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted when state S4 is reached
            sequence_detected <= (next_state == S4);
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // Allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

endmodule