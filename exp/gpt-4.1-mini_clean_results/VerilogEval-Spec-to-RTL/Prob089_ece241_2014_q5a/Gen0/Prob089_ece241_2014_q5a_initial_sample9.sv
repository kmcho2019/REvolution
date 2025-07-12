module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        COPY = 1'b0,
        INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Moore: output depends on state only)
    always @(*) begin
        case(state)
            COPY: begin
                z = x;                  // Output same as input
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                z = ~x;                 // Output inverted input
                next_state = INVERT;     // Stay in INVERT
            end
            default: begin
                z = 1'b0;
                next_state = COPY;
            end
        endcase
    end

endmodule