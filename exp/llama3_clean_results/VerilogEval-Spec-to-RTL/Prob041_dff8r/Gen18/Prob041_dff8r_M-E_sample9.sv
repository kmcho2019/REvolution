// Define a D flip-flop module
module DFF(
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    if (reset) q <= 0;
    else q <= d;
end

endmodule

// Define the TopModule using a shift register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Instantiate 8 D flip-flops in a daisy-chain configuration
DFF dff0(
   .clk(clk),
   .reset(reset),
   .d(d[0]),
   .q(q[0])
);

DFF dff1(
   .clk(clk),
   .reset(reset),
   .d(q[0]),
   .q(q[1])
);

DFF dff2(
   .clk(clk),
   .reset(reset),
   .d(q[1]),
   .q(q[2])
);

DFF dff3(
   .clk(clk),
   .reset(reset),
   .d(q[2]),
   .q(q[3])
);

DFF dff4(
   .clk(clk),
   .reset(reset),
   .d(q[3]),
   .q(q[4])
);

DFF dff5(
   .clk(clk),
   .reset(reset),
   .d(q[4]),
   .q(q[5])
);

DFF dff6(
   .clk(clk),
   .reset(reset),
   .d(q[5]),
   .q(q[6])
);

DFF dff7(
   .clk(clk),
   .reset(reset),
   .d(q[6]),
   .q(q[7])
);

endmodule