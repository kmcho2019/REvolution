module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct implementation of AND with bubble on in2
    assign out = in1 & ~in2;
endmodule