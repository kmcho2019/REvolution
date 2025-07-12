module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_delayed = 1'b0;

    always @(posedge clk) a_delayed <= a;

    // Directly use the registered version in combinational logic
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule