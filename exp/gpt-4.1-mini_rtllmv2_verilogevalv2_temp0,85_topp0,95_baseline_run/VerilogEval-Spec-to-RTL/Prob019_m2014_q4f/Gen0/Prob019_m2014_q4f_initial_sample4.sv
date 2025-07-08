module TopModule (
    input in1,
    input in2,
    output out
);

wire in2_inv;

assign in2_inv = ~in2;      // Bubble (inversion) on in2 input
assign out = in1 & in2_inv; // AND gate with inverted in2

endmodule