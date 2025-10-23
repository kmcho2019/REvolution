module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

wire a_prev = ~rst_n ? 1'b0 : (a ^ (a ^ a_prev)); // Implicit flip-flop using feedback

assign rise = rst_n ? (~a_prev & a) : 1'b0;
assign down = rst_n ? (a_prev & ~a) : 1'b0;

endmodule