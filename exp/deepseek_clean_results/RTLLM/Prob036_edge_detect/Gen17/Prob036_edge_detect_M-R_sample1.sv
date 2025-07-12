module edge_detect (
    input clk,
    input rst_n,  // Kept for interface compatibility
    input a,
    output rise,
    output down
);

    wire a_delayed;
    reg a_ff;

    // Explicit DFF implementation
    assign a_delayed = a_ff;
    always @(posedge clk) a_ff <= a;

    // Edge detection using simple AND gates
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule