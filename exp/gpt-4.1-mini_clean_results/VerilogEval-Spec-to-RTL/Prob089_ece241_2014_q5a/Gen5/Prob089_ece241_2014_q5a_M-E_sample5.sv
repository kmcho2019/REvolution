module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam WAIT_RST = 2'b00;
    localparam FIND_ONE = 2'b01;
    localparam INVERT   = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_RST: begin
                // Stay here while reset is asserted
                if (!areset)
                    next_state = FIND_ONE;
                else
                    next_state = WAIT_RST;
            end

            FIND_ONE: begin
                // If x is '1', move to INVERT; else stay FIND_ONE
                if (x)
                    next_state = INVERT;
                else
                    next_state = FIND_ONE;
            end

            INVERT: begin
                // Remain in INVERT indefinitely
                next_state = INVERT;
            end

            default: next_state = WAIT_RST;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_RST;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                WAIT_RST: z <= 1'b0;     // Output zero while reset active
                FIND_ONE: z <= x;        // Output input until first '1'
                INVERT:   z <= ~x;       // Output inverted input after first '1'
                default:  z <= 1'b0;
            endcase
        end
    end

endmodule