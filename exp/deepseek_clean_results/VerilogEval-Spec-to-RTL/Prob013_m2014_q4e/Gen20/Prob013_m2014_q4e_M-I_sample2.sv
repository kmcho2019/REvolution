module TopModule (
    input in1,
    input in2,
    output out
);
    assign out = ~(in1 | in2);  // Original optimal solution
    // Alternative: assign out = in1 ~| in2;  // Also correct and potentially clearer
endmodule