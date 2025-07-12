module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_FOR_RESET = 2'b00,
        COPY           = 2'b01,
        FLIP           = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic (Moore machine: output depends on state only)
    // However, in this problem, output depends on both state and input x, so z assigned in sequential block.

    always @(*) begin
        case(state)
            WAIT_FOR_RESET: next_state = (areset) ? WAIT_FOR_RESET : COPY;
            COPY:          next_state = (x == 1'b1) ? FLIP : COPY;
            FLIP:          next_state = FLIP;  // remain in FLIP until reset
            default:       next_state = WAIT_FOR_RESET;
        endcase
    end

    // Sequential logic: state transition and output z
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_RESET;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                WAIT_FOR_RESET: z <= 1'b0;
                COPY:          z <= x;
                FLIP:          z <= ~x;
                default:       z <= 1'b0;
            endcase
        end
    end

endmodule