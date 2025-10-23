module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Superior implementation of the NOR gate for clarity and direct logic representation
    assign out = ~(in1 | in2);
endmodule