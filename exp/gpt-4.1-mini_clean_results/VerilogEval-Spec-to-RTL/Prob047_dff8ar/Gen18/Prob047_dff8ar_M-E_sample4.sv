module DFF_1bit_AR (
    input       clk,
    input       areset,
    input       d,
    output reg  q
);
    // Single-bit D flip-flop with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);

    // Instantiate eight single-bit D flip-flops with async reset
    DFF_1bit_AR dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF_1bit_AR dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF_1bit_AR dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF_1bit_AR dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF_1bit_AR dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF_1bit_AR dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF_1bit_AR dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF_1bit_AR dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));

endmodule