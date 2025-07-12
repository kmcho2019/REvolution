module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] history;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) history <= 3'b0;
        else history <= {history[1:0], x};

    assign z = (history == 3'b101);

endmodule