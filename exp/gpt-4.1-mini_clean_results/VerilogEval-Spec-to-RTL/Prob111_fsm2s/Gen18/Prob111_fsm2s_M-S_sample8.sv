module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF state
        else if (!state)
            state <= j ? 1'b1 : 1'b0; // OFF: j=1 -> ON; j=0 -> OFF
        else
            state <= k ? 1'b0 : 1'b1; // ON: k=1 -> OFF; k=0 -> ON
    end

    assign out = state;

endmodule