module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] history;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) history <= 2'b0;
        else history <= {history[0], x};

    assign z = (history == 2'b10) & x;

endmodule