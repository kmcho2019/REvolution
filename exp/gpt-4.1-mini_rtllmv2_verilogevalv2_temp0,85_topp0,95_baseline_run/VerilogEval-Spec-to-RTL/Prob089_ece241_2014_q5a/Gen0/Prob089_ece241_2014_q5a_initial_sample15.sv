module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam STATE_COPY   = 1'b0;
    localparam STATE_INVERT = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_COPY: 
                // Stay in COPY until the first '1' bit is found
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_COPY;
            STATE_INVERT:
                // Once in INVERT, stay there
                next_state = STATE_INVERT;
            default:
                next_state = STATE_COPY;
        endcase
    end

    // Output logic (Moore machine: output depends on state and input)
    always @(*) begin
        case (state)
            STATE_COPY:   z = x;      // output the same bit
            STATE_INVERT: z = ~x;     // output inverted bit
            default:      z = x;
        endcase
    end

endmodule