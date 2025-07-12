module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam WAIT   = 1'b0; // Waiting for first '1'
    localparam INVERT = 1'b1; // Inverting subsequent bits

    reg state, next_state;

    // State and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends only on state and current input x
            case (state)
                WAIT:   z <= x;       // Pass input until first '1'
                INVERT: z <= ~x;      // Invert subsequent bits
                default: z <= 1'b0;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT:   next_state = (x == 1'b1) ? INVERT : WAIT;
            INVERT: next_state = INVERT;
            default: next_state = WAIT;
        endcase
    end

endmodule