module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Define FSM states
    typedef enum logic [1:0] {
        WAIT_FOR_LSB = 2'd0,   // Before processing, waiting for first bit (LSB)
        COPY_BITS    = 2'd1,   // Copy input bits until first '1' bit processed
        INVERT_BITS  = 2'd2    // Invert remaining bits
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= WAIT_FOR_LSB;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            WAIT_FOR_LSB: begin
                // Wait for first input bit; transition to COPY_BITS immediately
                // This effectively treats first bit as LSB to copy
                next_state = COPY_BITS;
            end

            COPY_BITS: begin
                // Remain in COPY_BITS until we see a '1' bit on input x
                // When x == 1, transition to INVERT_BITS
                if (x == 1'b1)
                    next_state = INVERT_BITS;
                else
                    next_state = COPY_BITS;
            end

            INVERT_BITS: begin
                // Stay in INVERT_BITS, inverting input bits serially
                next_state = INVERT_BITS;
            end

            default: begin
                next_state = WAIT_FOR_LSB;
            end
        endcase
    end

    // Output logic (Moore output depends only on state and input x)
    // z = x when state == WAIT_FOR_LSB or COPY_BITS (copy input bits)
    // z = ~x when state == INVERT_BITS (invert bits)
    assign z = (state == INVERT_BITS) ? ~x : x;

endmodule