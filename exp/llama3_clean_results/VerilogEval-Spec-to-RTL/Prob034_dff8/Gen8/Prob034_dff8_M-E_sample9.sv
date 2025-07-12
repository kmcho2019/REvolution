// Define a basic D flip-flop module
module DFF(
    input clk,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    q <= d;  // Load d into q on the positive edge of clk
end

endmodule

// Define the TopModule using the hierarchical design
module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

// Instantiate 8 DFF modules for each bit of 'd'
DFF dff_0(clk, d[0], q[0]);
DFF dff_1(clk, d[1], q[1]);
DFF dff_2(clk, d[2], q[2]);
DFF dff_3(clk, d[3], q[3]);
DFF dff_4(clk, d[4], q[4]);
DFF dff_5(clk, d[5], q[5]);
DFF dff_6(clk, d[6], q[6]);
DFF dff_7(clk, d[7], q[7]);

endmodule