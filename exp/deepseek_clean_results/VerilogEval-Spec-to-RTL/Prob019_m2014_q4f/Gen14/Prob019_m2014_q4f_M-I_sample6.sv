module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Output is in1 AND (NOT in2)
    assign out = in1 & (~in2);
endmodule