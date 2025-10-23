module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Define states for pattern matching
    typedef enum logic [2:0] {
        IDLE,       // No match yet
        GOT1,       // First '1' matched
        GOT11,      // "11" matched
        GOT110,     // "110" matched
        MATCHED     // Full "1101" matched
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE:    next_state = data ? GOT1 : IDLE;
            GOT1:    next_state = data ? GOT11 : IDLE;
            GOT11:   next_state = data ? GOT11 : GOT110;
            GOT110:  next_state = data ? MATCHED : IDLE;
            MATCHED: next_state = MATCHED;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign start_shifting = (current_state == MATCHED);

endmodule