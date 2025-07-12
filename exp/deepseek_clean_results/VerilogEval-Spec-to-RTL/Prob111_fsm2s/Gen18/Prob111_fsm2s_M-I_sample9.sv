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
            state <= 1'b0;
        else
            state <= (state & ~k) | (~state & j);
    end

    assign out = state;

endmodule