module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam WAIT_FOR_ONE = 1'b0;
    localparam INVERT_REST = 1'b1;

    reg state;
    reg x_delayed;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_ONE;
            x_delayed <= 1'b0;
        end else begin
            x_delayed <= x; // Delay input for Moore output
            case (state)
                WAIT_FOR_ONE: begin
                    if (x == 1'b1)
                        state <= INVERT_REST;
                    else
                        state <= WAIT_FOR_ONE;
                end
                INVERT_REST: begin
                    state <= INVERT_REST; // Stay here indefinitely after first '1'
                end
                default: state <= WAIT_FOR_ONE;
            endcase
        end
    end

    // Moore output: depends only on state and delayed input
    always @(*) begin
        case (state)
            WAIT_FOR_ONE: z = 1'b0;         // Before first '1', output zero
            INVERT_REST:  z = ~x_delayed;   // After first '1', invert delayed input
            default:      z = 1'b0;
        endcase
    end

endmodule