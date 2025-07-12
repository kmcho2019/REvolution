module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) state <= 1'b0;
        else state <= (~state & x) | (state & ~x);

    assign z = state & x;

endmodule