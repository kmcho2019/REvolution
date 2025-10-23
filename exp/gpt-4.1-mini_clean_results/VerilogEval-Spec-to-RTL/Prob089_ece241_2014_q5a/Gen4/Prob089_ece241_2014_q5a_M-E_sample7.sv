module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT    = 2'b00, // No '1' encountered yet; output 0
        FIRST   = 2'b01, // First '1' encountered; output 1
        INVERT  = 2'b10  // Subsequent bits inverted
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends only on current state
            case (state)
                WAIT:  z <= 1'b0;       // Before first '1', output zero
                FIRST: z <= 1'b1;       // Output 1 for first '1' bit
                INVERT: z <= ~x;        // Invert input bits after first '1'
                default: z <= 1'b0;
            endcase
        end
    end

    // Next state logic: transitions based on current state and input x
    always @(*) begin
        case (state)
            WAIT:   next_state = x ? FIRST : WAIT;       // Wait for first '1' bit
            FIRST:  next_state = INVERT;                  // After first '1', go to INVERT
            INVERT: next_state = INVERT;                  // Stay in INVERT
            default: next_state = WAIT;
        endcase
    end

endmodule