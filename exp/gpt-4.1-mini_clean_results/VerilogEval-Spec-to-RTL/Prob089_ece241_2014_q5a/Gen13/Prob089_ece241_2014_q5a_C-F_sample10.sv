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

    // Combinational next state logic based on current state and sampled input
    always @(*) begin
        case (state)
            1'b0: next_state = (x_reg == 1'b1) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    // Sequential logic: asynchronous reset, sample input and update state together on clk
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Moore output: XOR of sampled input and state (0: pass bit, 1: invert bit)
    assign z = x_reg ^ state;

endmodule