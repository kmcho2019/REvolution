module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly implement 2-input NOR gate with a single assign statement
    assign out = ~(in1 | in2);
endmodule