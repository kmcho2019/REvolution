module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State definitions - 3-bit encoding for 5 states (optimal)
    typedef enum logic [2:0] {
        IDLE,   // Initial state, no match
        S1,     // '1' received
        S2,     // '11' received
        S3,     // '110' received
        FOUND   // '1101' received (terminal state until reset)
    } state_t;

    reg [2:0] current_state, next_state;

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational next-state logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = data ? S1 : IDLE;     // Start sequence on '1'
            S1:    next_state = data ? S2 : IDLE;     // Second '1' needed
            S2:    next_state = data ? S2 : S3;       // Stay on '1's, move to S3 on '0'
            S3:    next_state = data ? FOUND : IDLE;  // Final '1' completes sequence
            FOUND: next_state = FOUND;               // Lock in FOUND state
        endcase
    end

    // Output is high only when sequence is found
    always @(*) begin
        start_shifting = (current_state == FOUND);
    end

endmodule