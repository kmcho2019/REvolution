module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding:
    // 0 = before first '1' seen
    // 1 = after first '1' seen
    reg state, next_state;

    // Next state logic combinationally determined
    always @(*) begin
        if (state == 1'b0) begin
            // If x is 1, transition to state 1; else remain
            next_state = x ? 1'b1 : 1'b0;
        end else begin
            // Once in state 1, remain in state 1
            next_state = 1'b1;
        end
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Output combinational logic (Mealy output)
    assign z = (state == 1'b0) ? x : ~x;

endmodule