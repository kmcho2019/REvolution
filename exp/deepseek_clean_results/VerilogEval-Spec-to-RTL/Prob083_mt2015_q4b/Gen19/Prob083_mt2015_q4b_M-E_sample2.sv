module TopModule (
    input x,
    input y,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        STATE_00,
        STATE_01,
        STATE_10,
        STATE_11
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Initial state (matches waveform)
    initial begin
        current_state = STATE_00;
        z = 1;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_00: next_state = {x,y};
            STATE_01: next_state = {x,y};
            STATE_10: next_state = {x,y};
            STATE_11: next_state = {x,y};
        endcase
    end

    // Output logic and state transition
    always @(posedge x or posedge y) begin
        current_state <= next_state;
        z <= (current_state == {x,y});
    end

endmodule