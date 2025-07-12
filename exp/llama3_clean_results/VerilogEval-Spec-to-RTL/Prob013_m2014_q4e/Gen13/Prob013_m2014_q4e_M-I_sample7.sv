module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Retain the existing efficient implementation of the NOR gate
    assign out = ~(in1) & ~(in2);
endmodule