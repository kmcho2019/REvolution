module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Direct and concise implementation of the NOR gate using basic logical operators
    assign out = ~(in1 | in2);
endmodule