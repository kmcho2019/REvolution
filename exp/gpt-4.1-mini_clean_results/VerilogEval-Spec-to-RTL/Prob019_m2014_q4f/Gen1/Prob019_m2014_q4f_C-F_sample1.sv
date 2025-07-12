module TopModule (
    input  in1,
    input  in2,
    output out
);

// Implement AND gate with bubble on in2 input: out = in1 AND (NOT in2)
assign out = in1 & ~in2;

endmodule