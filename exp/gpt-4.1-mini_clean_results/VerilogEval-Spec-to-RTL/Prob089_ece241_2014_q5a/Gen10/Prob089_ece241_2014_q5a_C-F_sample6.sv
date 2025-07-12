module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding:
    // 0 = COPY bits (pass bits as-is until first '1')
    // 1 = INVERT bits (invert bits after first '1' to produce two's complement)
    reg state;
    reg x_reg;

    reg next_state;
    reg next_x_reg;

    // Combinational logic: determine next state and sample input
    always @(*) begin
        next_x_reg = x;
        case(state)
            1'b0: // COPY state: wait for first '1'
                next_state = (x_reg == 1'b1) ? 1'b1 : 1'b0;
            1'b1: // INVERT state: stay inverted
                next_state = 1'b1;
            default:
                next_state = 1'b0;
        endcase
    end

    // Sequential logic: update state and sampled input with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= next_x_reg;
        end
    end

    // Moore output: XOR of sampled input and state (inversion active)
    assign z = x_reg ^ state;

endmodule