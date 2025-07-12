module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Explicit equality comparison to maximize synthesis tool's ability to infer optimized comparator logic
assign z = (A == B);

endmodule