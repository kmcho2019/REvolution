module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;

    // Clocked register using continuous assignment
    assign a_prev = !rst_n ? 1'b0 : (posedge clk ? a : a_prev);

    // Compact edge detection
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule