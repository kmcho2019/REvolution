module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Implement out = in1 AND (NOT in2) directly using bitwise operations
    assign out = in1 & ~in2;
endmodule