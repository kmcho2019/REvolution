module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;       // OFF state
        else if (state == 1'b0)
            state <= j ? 1'b1 : 1'b0;
        else
            state <= k ? 1'b0 : 1'b1;
    end

    // Moore output depends only on state
    assign out = state;

endmodule