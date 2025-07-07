module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        COPY   = 1'b0,
        INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            COPY: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output logic (Moore output depends on state and input)
    always @(*) begin
        if (areset)
            z = 1'b0;
        else begin
            case (state)
                COPY:   z = x;
                INVERT: z = ~x;
                default: z = 1'b0;
            endcase
        end
    end

endmodule