module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement NOR directly in one expression
    assign out = ~(in1 | in2);
endmodule