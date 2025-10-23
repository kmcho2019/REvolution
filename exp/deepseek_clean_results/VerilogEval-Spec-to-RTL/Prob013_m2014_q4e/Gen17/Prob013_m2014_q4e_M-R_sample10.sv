module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement NOR using continuous assignment
    assign out = ~(in1 | in2);
endmodule