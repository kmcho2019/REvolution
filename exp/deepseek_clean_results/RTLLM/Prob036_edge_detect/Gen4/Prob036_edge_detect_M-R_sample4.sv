module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;

    // Sequential element implemented with continuous assignment
    assign a_prev = !rst_n ? 1'b0 : (posedge clk ? a : a_prev);

    // Combinational edge detection
    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule