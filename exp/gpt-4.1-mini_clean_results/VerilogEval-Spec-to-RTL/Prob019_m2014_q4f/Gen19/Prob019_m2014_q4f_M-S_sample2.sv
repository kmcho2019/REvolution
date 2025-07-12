module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement AND gate with inverted in2 using a simple assign statement
    assign out = in1 & ~in2;
endmodule