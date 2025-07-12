module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // States
    typedef enum logic [0:0] {
        STATE_COPY   = 1'b0,
        STATE_INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
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

    // Output logic (Moore machine: output depends on state only)
    // Here output depends on state and current input
    always @(*) begin
        case (state)
            STATE_COPY:   z = x;
            STATE_INVERT: z = ~x;
            default:      z = 1'b0;
        endcase
    end

endmodule