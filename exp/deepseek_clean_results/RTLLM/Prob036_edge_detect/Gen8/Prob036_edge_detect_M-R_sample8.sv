module edge_detect (
    input  clk,
    input  rst_n,
    input  a,
    output rise,
    output down
);

    reg a_prev = 0;

    always @(posedge clk) a_prev <= !rst_n ? 0 : a;

    assign rise = !a_prev && a;
    assign down = a_prev && !a;

endmodule