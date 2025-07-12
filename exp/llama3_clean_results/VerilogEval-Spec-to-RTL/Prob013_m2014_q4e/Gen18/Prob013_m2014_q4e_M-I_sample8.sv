module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Alternative expression for a 2-input NOR gate
    assign out = ~(in1) & ~(in2);
endmodule