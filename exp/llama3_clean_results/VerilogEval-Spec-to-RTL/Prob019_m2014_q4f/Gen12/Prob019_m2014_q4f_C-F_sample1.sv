module TopModule(
    input  in1,
    input  in2,
    output out
);
// Explicitly invert in2 before AND operation for clarity
assign out = in1 & (~in2);
endmodule