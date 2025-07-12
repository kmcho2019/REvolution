// Define a separate D flip-flop module
module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// Instantiate 8 D flip-flops in the TopModule
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 D flip-flops
DFF dff0(clk, d[0], q[0]);
DFF dff1(clk, d[1], q[1]);
DFF dff2(clk, d[2], q[2]);
DFF dff3(clk, d[3], q[3]);
DFF dff4(clk, d[4], q[4]);
DFF dff5(clk, d[5], q[5]);
DFF dff6(clk, d[6], q[6]);
DFF dff7(clk, d[7], q[7]);

endmodule