module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly invert in2 and AND with in1 in a single continuous assignment
    assign out = in1 & (~in2);
endmodule