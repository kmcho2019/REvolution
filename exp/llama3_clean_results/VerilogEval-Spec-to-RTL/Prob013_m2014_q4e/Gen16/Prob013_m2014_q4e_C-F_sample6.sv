module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Superior implementation of the NOR gate using bitwise operators
    assign out = ~(in1 | in2);
endmodule