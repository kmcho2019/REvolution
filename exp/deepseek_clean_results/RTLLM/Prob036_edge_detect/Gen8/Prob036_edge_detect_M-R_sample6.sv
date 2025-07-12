module edge_detect (
    input  clk,
    input  rst_n,
    input  a,
    output rise,
    output down
);

    reg a_prev;

    // Clocked assignment with reset using ternary operator
    assign a_prev = !rst_n ? 1'b0 : (posedge clk ? a : a_prev);

    // Edge detection remains the same
    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule