module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT  = 2'b00,  // waiting for first '1'
        COPY  = 2'b01,  // output first '1' as is
        INVERT= 2'b10   // output inverted bits thereafter
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            WAIT:  next_state = (x == 1'b1) ? COPY : WAIT;
            COPY:  next_state = INVERT;
            INVERT:next_state = INVERT;
            default: next_state = WAIT;
        endcase
    end

    // Output logic (Moore output)
    always @(*) begin
        case (state)
            WAIT:   z = x;       // pass input directly until first '1'
            COPY:   z = 1'b1;    // output the first '1' as is
            INVERT: z = ~x;      // invert all subsequent bits
            default: z = 1'b0;
        endcase
    end

endmodule