module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Implement AND gate with a bubble (inversion) on in2 using a single continuous assignment
    assign out = in1 & ~in2;
endmodule