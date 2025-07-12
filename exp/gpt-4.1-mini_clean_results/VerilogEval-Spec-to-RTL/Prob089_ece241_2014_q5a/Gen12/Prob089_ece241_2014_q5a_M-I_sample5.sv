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

    // Next state logic: direct combinational expression based on current state and x_reg
    wire next_state = (state == 1'b0 && x_reg == 1'b1) ? 1'b1 : state;

    // Sequential logic: update state and sample input on clock or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Moore output: XOR of sampled input and state (inversion active)
    assign z = x_reg ^ state;

endmodule