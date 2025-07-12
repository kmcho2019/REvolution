module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding: 0 = A (output 0), 1 = B (output 1)
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;      // Asynchronously reset to state B (output=1)
        else
            state <= state ^ ~in; // Next state logic per FSM transitions
    end

    assign out = state; // Moore output directly from current state

endmodule