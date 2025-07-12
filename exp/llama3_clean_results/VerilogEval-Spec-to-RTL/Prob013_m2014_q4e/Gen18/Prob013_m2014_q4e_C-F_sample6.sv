module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Direct and efficient implementation of a 2-input NOR gate
    assign out = ~in1 & ~in2;
endmodule