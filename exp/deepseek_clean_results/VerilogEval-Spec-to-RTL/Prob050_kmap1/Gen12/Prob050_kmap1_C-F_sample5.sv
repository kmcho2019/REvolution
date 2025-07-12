module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal fused implementation - simple, readable, and efficient
    assign out = a | b | c;
endmodule