module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding:
    // 0 = COPY bits until first '1'
    // 1 = INVERT bits after first '1'
    reg state;
    reg x_reg;

    reg next_state;
    reg next_x_reg;

    // Combinational logic: determine next state and sample input only when FSM active
    always @(*) begin
        // Default next values
        next_x_reg = x_reg;
        next_state = state;
        if (~areset) begin
            // Sample input x only when not in reset to reduce toggling of x_reg
            next_x_reg = x;
            case(state)
                1'b0: // COPY state: move to INVERT at first '1'
                    next_state = (x == 1'b1) ? 1'b1 : 1'b0;
                1'b1: // INVERT state stays active
                    next_state = 1'b1;
                default:
                    next_state = 1'b0;
            endcase
        end
    end

    // Sequential logic with asynchronous reset: update state and sampled input
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= next_x_reg;
        end
    end

    // Moore output: XOR of sampled input and current state
    assign z = x_reg ^ state;

endmodule