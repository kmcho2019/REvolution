module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Implement the function directly with inline expression:
    // out = in1 AND (NOT in2)
    assign out = in1 & ~in2;
endmodule