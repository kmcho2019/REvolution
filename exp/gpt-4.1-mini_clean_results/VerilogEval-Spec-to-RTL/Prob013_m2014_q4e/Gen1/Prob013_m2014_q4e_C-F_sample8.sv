module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Output is NOR of inputs: out = ~(in1 | in2)
    assign out = ~(in1 | in2);
endmodule