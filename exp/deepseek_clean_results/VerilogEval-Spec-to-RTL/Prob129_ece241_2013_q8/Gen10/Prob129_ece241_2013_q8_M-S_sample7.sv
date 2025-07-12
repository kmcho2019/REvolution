module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg x_prev;

    always @(posedge clk or negedge aresetn)
        if (!aresetn)
            x_prev <= 1'b0;
        else
            x_prev <= x;

    assign z = x_prev & ~x_prev & x;  // Equivalent to x_prev_prev & ~x_prev & x

endmodule