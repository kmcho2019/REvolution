module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    typedef enum logic [0:0] {
        WAIT_FOR_FIRST_ONE = 1'b0,
        INVERT_BITS        = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_FIRST_ONE: begin
                if (x == 1'b1)
                    next_state = INVERT_BITS;
                else
                    next_state = WAIT_FOR_FIRST_ONE;
            end
            INVERT_BITS: begin
                next_state = INVERT_BITS;
            end
            default: next_state = WAIT_FOR_FIRST_ONE;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_FIRST_ONE;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0; // output zero on reset
        else begin
            case(state)
                WAIT_FOR_FIRST_ONE: z <= x;
                INVERT_BITS:        z <= ~x;
                default:            z <= 1'b0;
            endcase
        end
    end

endmodule