module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct NOR implementation using continuous assignment
    assign out = ~(in1 | in2);
endmodule