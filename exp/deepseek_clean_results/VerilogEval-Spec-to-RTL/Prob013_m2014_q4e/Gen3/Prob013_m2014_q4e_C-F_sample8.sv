module TopModule (
    input in1,
    input in2,
    output out
);
    // 2-input NOR gate: out = ~(in1 | in2)
    assign out = ~(in1 | in2);
endmodule