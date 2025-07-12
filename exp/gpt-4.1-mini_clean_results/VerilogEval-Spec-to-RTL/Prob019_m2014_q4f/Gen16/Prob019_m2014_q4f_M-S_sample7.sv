module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Implement AND gate with bubble on in2 by directly assigning out
    assign out = in1 & ~in2;
endmodule