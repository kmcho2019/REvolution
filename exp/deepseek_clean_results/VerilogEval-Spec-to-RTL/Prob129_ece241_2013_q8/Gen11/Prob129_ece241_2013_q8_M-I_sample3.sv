module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg hist0, hist1;  // Separate flip-flops for each history bit

    always @(posedge clk or negedge aresetn)
        if (!aresetn) {hist1, hist0} <= 2'b0;
        else {hist1, hist0} <= {hist0, x};

    assign z = hist1 & ~hist0 & x;  // Equivalent to (hist == 2'b10) & x

endmodule