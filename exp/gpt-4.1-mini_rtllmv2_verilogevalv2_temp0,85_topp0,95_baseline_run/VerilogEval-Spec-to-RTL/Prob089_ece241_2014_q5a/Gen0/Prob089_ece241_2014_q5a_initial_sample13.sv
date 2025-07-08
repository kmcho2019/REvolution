module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output logic (Moore output depends only on state and input)
    always @(*) begin
        case (state)
            COPY:   z = x;         // output input bit until first '1' detected
            INVERT: z = ~x;        // invert all bits after first '1'
            default: z = 1'b0;
        endcase
    end

endmodule