module edge_detect (
    input  clk,
    input  rst_n,
    input  a,
    output rise,
    output down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) a_prev <= 0;
        else        a_prev <= a;
    end

    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule