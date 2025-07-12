module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Direct assign statement for 2-input NOR operation
    assign out = ~(in1 | in2);
endmodule