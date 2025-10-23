module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE            = 2'b00,
        PASS_THROUGH    = 2'b01,
        INVERT_AND_CARRY= 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                // On reset release, go to PASS_THROUGH to start processing bits
                next_state = PASS_THROUGH;
            end

            PASS_THROUGH: begin
                // If input bit is 1, move to INVERT_AND_CARRY; else stay
                if (x == 1'b1)
                    next_state = INVERT_AND_CARRY;
                else
                    next_state = PASS_THROUGH;
            end

            INVERT_AND_CARRY: begin
                // Remain in INVERT_AND_CARRY indefinitely
                next_state = INVERT_AND_CARRY;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: Moore output depends only on current state and input x
    always @(*) begin
        case(state)
            IDLE:            z = 1'b0;     // output zero during reset or idle
            PASS_THROUGH:    z = x;        // output input bit as is
            INVERT_AND_CARRY:z = ~x;       // output inverted input bit
            default:         z = 1'b0;
        endcase
    end

endmodule