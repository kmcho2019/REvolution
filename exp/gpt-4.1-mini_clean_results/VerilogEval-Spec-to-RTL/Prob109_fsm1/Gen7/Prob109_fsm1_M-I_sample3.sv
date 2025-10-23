module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;        // 0 = A, 1 = B
    wire next_state;

    assign next_state = (state ^ ~in); // combinational next state logic

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= next_state;
    end

    assign out = state;

endmodule