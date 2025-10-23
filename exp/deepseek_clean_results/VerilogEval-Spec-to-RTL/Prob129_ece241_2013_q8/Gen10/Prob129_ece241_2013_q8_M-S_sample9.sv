module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg seen_10;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) seen_10 <= 1'b0;
        else seen_10 <= (~seen_10 & x) | (seen_10 & ~x);

    assign z = seen_10 & x;

endmodule