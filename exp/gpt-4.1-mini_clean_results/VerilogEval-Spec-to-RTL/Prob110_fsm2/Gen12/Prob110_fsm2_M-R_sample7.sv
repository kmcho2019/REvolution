module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        if (state == 1'b0)        // OFF state
            next_state = j ? 1'b1 : 1'b0;
        else                     // ON state
            next_state = k ? 1'b0 : 1'b1;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;        // OFF state
        else
            state <= next_state;
    end

    // Moore output is state itself
    assign out = state;

endmodule