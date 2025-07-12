module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg history_1, history_0;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) {history_1, history_0} <= 2'b0;
        else {history_1, history_0} <= {history_0, x};

    assign z = history_1 & ~history_0 & x;

endmodule