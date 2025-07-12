module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct implementation using AND with inverted input
    assign out = in1 & ~in2;
endmodule