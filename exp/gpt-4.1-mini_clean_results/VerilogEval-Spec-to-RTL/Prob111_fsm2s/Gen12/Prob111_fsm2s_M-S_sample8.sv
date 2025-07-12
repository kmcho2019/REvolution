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
            state <= 1'b0;        // OFF state
        else if (!state)
            state <= j ? 1'b1 : 1'b0;  // OFF: if j=1 go ON, else stay OFF
        else
            state <= k ? 1'b0 : 1'b1;  // ON: if k=1 go OFF, else stay ON
    end

    assign out = state;  // output = 1 when ON, 0 when OFF

endmodule