module TopModule (
    input  in1,
    input  in2,
    output out
);

// Implement AND gate with bubble (inversion) on in2 input using continuous assignment
assign out = in1 & ~in2;

endmodule