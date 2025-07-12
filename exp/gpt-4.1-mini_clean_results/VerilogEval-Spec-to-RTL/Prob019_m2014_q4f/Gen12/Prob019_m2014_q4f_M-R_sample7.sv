module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly assign output as AND of in1 and inverted in2
    assign out = in1 & (~in2);
endmodule