module TopModule (
    input in1,
    input in2,
    output out
);
    // Same logical implementation but hints at potential technology mapping optimization
    assign out = in1 & (~in2);
endmodule