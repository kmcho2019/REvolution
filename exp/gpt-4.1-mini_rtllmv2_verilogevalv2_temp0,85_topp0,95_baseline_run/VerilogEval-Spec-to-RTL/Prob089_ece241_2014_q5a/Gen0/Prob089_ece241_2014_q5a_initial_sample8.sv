module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT = 2'b00,  // Waiting for reset release
        ZERO = 2'b01,  // No '1' bit encountered yet, output x
        ONES = 2'b10   // First '1' found, output inverted x
    } state_t;

    state_t state, next_state;

    // State transition (with asynchronous reset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT: begin
                // When reset released, start processing
                next_state = ZERO;
            end
            ZERO: begin
                // If input bit is '1', transition to ONES
                if (x == 1'b1)
                    next_state = ONES;
                else
                    next_state = ZERO;
            end
            ONES: begin
                // Remain in ONES
                next_state = ONES;
            end
            default: next_state = WAIT;
        endcase
    end

    // Output logic (Moore machine, depends on state)
    always @(*) begin
        case (state)
            WAIT: z = 1'b0;          // Output zero in reset
            ZERO: z = x;             // Copy input bit until first '1'
            ONES: z = ~x;            // Invert input bit after first '1'
            default: z = 1'b0;
        endcase
    end

endmodule