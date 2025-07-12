module TopModule (
    input in1,
    input in2,
    output out
);
    assign #1 out = ~(in1 | in2);  // Using NOR operator with unit delay
endmodule