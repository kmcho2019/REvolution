module edge_detect (
    input clk,
    input rst_n,  // Kept for interface compatibility
    input a,
    output rise,
    output down
);

    wire a_delayed;
    wire a_next = a;
    reg a_ff;

    // Explicit DFF implementation using continuous assignment
    always @(posedge clk) a_ff <= a_next;
    assign a_delayed = a_ff;

    // Edge detection using simple AND gates
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule