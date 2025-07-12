// Define a module for a single D flip-flop
module DFlipFlop(
    input clk,
    input d_in,
    output reg q_out
);

always @(posedge clk) begin
    q_out = d_in;
end

endmodule

// TopModule that instantiates 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 D flip-flops
DFlipFlop dff0(clk, d[0], q[0]);
DFlipFlop dff1(clk, d[1], q[1]);
DFlipFlop dff2(clk, d[2], q[2]);
DFlipFlop dff3(clk, d[3], q[3]);
DFlipFlop dff4(clk, d[4], q[4]);
DFlipFlop dff5(clk, d[5], q[5]);
DFlipFlop dff6(clk, d[6], q[6]);
DFlipFlop dff7(clk, d[7], q[7]);

endmodule