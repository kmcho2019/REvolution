module TopModule (
    input x,
    input y,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_A: next_state = (x == y) ? STATE_A : STATE_B;
            STATE_B: next_state = (x == y) ? STATE_C : STATE_B;
            STATE_C: next_state = (x == y) ? STATE_C : STATE_B;
            default: next_state = STATE_A;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        case (current_state)
            STATE_A: z = 1'b1;
            STATE_B: z = 1'b0;
            STATE_C: z = 1'b1;
            default: z = 1'b1;
        endcase
    end

    // State register
    always @(posedge x or posedge y) begin
        current_state <= next_state;
    end

    // Initial state
    initial begin
        current_state = STATE_A;
    end

endmodule