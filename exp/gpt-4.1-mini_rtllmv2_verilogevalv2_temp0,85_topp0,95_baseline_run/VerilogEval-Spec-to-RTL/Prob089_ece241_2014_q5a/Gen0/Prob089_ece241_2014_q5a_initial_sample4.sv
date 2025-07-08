module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam STATE_COPY   = 1'b0;
    localparam STATE_INVERT = 1'b1;

    reg state, next_state;

    // Next state logic and output logic (Moore: output depends on state only)
    always @(*) begin
        case(state)
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

    // Output logic (Moore output)
    // If in STATE_COPY, output equals input bit x
    // If in STATE_INVERT, output is inverted input bit
    always @(*) begin
        case(state)
            STATE_COPY:   z = x;
            STATE_INVERT: z = ~x;
            default:      z = 1'b0;
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_COPY;
        else
            state <= next_state;
    end

endmodule