module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n)
        a_prev <= !rst_n ? 1'b0 : a;

    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule