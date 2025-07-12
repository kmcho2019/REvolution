module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] shift;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) shift <= 2'b0;
        else shift <= {shift[0], x};

    assign z = (shift == 2'b10) & x;

endmodule