module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Superior implementation of the NOR gate using bitwise operators
    // Alternative implementation: assign out = ~(in1 | in2);
    assign out = ~(in1) & ~(in2);
endmodule