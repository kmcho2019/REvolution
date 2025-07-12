module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using enums for clarity
    typedef enum logic [2:0] {
        IDLE = 3'd0,   // No bits matched
        S1   = 3'd1,   // Matched '1'
        S2   = 3'd2,   // Matched '10'
        S3   = 3'd3,   // Matched '100'
        S4   = 3'd4    // Matched '1001' (final)
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:   next_state = (data_in == 1'b1) ? S4 : S2;
            S4:   next_state = (data_in == 1'b1) ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted synchronously when FSM enters S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule