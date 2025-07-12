module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // FSM state encoding
    // 0: COPY bits until first '1'
    // 1: INVERT bits after first '1'
    reg state;
    reg x_reg;
    reg next_state;

    // Combinational next state logic based on registered input and state
    always @(*) begin
        if (state == 1'b0)
            next_state = (x_reg == 1'b1) ? 1'b1 : 1'b0;
        else
            next_state = 1'b1;
    end

    // Sequential logic: asynchronous reset, sample input and update state on clk
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Moore output: XOR of sampled input and FSM state
    assign z = x_reg ^ state;

endmodule