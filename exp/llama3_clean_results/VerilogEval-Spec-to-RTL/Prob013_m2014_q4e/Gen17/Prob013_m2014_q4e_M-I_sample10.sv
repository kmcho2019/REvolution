module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Optimized implementation of the NOR gate, focusing on simplicity and direct logic representation
    assign out = ~(in1 | in2);
endmodule