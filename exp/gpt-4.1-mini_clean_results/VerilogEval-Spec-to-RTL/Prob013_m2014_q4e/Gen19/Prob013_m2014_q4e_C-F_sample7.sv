module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct implementation of 2-input NOR gate with a single assign statement
    assign out = ~(in1 | in2);
endmodule