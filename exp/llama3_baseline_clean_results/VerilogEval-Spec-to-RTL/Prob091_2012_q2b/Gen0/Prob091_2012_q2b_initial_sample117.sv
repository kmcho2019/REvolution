module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be 1 when the next state is B, which can happen from A with w=1 or from D with w=1
assign Y1 = (y[3] && w); // State D with w=1 goes to B

// Y3 should be 1 when the next state is D, which can happen from B with w=0, C with w=0, D with w=0, or E with w=0
assign Y3 = (~w && (y[1] || y[2] || y[3] || y[4])); // If w=0 and current state is B, C, D, or E

endmodule