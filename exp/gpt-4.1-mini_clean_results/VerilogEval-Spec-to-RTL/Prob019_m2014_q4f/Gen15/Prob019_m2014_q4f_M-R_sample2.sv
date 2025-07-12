module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct continuous assignment modeling AND gate with bubble on in2 (inverted in2)
    assign out = in1 & ~in2;
endmodule