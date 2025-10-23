module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;   // FSM state: 0 = before carry, 1 = after carry
    reg x_reg;   // Registered input bit

    // Combined input sampling and state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            state <= state | x_reg; // Transition to after carry on first sampled '1'
        end
    end

    // Moore output: invert input bit after first carry encountered
    assign z = x_reg ^ state;

endmodule