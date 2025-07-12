module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // One-hot encoded states
    localparam IDLE         = 3'b001;
    localparam WAIT_FOR_LSB = 3'b010;
    localparam INVERTING    = 3'b100;

    reg [2:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: next_state = WAIT_FOR_LSB;
            WAIT_FOR_LSB:
                if (x == 1'b1)
                    next_state = INVERTING;
                else
                    next_state = WAIT_FOR_LSB;
            INVERTING: next_state = INVERTING;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: Moore output depends on state and input
    // IDLE: output 0 (idle)
    // WAIT_FOR_LSB: output x (pass through bits until first '1')
    // INVERTING: output inverted x (invert subsequent bits)
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else begin
            case (state)
                IDLE:         z <= 1'b0;
                WAIT_FOR_LSB: z <= x;
                INVERTING:    z <= ~x;
                default:      z <= 1'b0;
            endcase
        end
    end

endmodule