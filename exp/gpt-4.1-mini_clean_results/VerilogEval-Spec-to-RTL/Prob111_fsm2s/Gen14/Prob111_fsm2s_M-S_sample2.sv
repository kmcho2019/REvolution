module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;          // OFF state
        else if (!state)
            state <= j ? 1'b1 : 1'b0; // OFF: j=1 -> ON; else OFF
        else
            state <= k ? 1'b0 : 1'b1; // ON: k=1 -> OFF; else ON
    end

    assign out = state;

endmodule