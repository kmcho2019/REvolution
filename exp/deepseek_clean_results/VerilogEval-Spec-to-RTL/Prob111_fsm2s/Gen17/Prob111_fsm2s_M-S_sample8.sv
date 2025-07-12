module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state = 0;  // Default to OFF state

    always @(posedge clk) begin
        if (reset)
            state <= 0;
        else
            state <= state ? ~k : j;
    end

    assign out = state;

endmodule