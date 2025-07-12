module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Directly implementing a NOR gate using a conditional statement
    assign out = ~(in1 | in2);
endmodule