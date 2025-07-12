module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        STATE_COPY = 1'b0,
        STATE_INVERT = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= STATE_COPY;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_COPY: begin
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_COPY;
            end
            STATE_INVERT: begin
                next_state = STATE_INVERT;
            end
            default: next_state = STATE_COPY;
        endcase
    end

    // Output logic (Moore FSM: output depends on current_state and input x)
    always @(*) begin
        if (areset)
            z = 1'b0;  // output zero when reset asserted
        else begin
            case (current_state)
                STATE_COPY: z = x;
                STATE_INVERT: z = ~x;
                default: z = 1'b0;
            endcase
        end
    end

endmodule