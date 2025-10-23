module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Directly implement NOR using ~ and |
    assign out = ~(in1 | in2);
endmodule