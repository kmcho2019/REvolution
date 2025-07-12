module TopModule (
    input x,
    input y,
    output reg z
);
    // State definition
    typedef enum logic {SAME, DIFF} state_t;
    state_t current_state;

    // State transition and output logic
    always @(*) begin
        case(current_state)
            SAME: z = 1'b1;
            DIFF: z = 1'b0;
        endcase
    end

    // Next state logic
    always @(*) begin
        if (x == y)
            current_state = SAME;
        else
            current_state = DIFF;
    end

    // Initial state
    initial begin
        current_state = SAME;
    end
endmodule