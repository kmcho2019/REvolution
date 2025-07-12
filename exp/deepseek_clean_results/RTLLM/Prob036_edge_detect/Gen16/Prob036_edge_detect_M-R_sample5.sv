module edge_detect (
    input clk,
    input rst_n,  // Kept for interface compatibility
    input a,
    output rise,
    output down
);

    wire a_delayed;
    reg a_ff;

    // Explicit DFF implementation using continuous assignment
    assign a_delayed = a_ff;
    always @(posedge clk) a_ff <= a;

    // Edge detection using ternary operators
    assign rise = (a && !a_delayed) ? 1'b1 : 1'b0;
    assign down = (!a && a_delayed) ? 1'b1 : 1'b0;

endmodule