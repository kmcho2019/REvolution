module TopModule (
    input  in1,
    input  in2,
    output wire out
);

// Implement AND gate with bubble (inversion) on in2 input
assign out = in1 & ~in2;

endmodule