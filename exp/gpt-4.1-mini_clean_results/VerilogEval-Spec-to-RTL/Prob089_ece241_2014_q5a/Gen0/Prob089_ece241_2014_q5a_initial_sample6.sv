module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        COPY   = 1'b0,
        INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Output logic (Moore machine)
    always @(*) begin
        case(state)
            COPY:   z = x;
            INVERT: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule