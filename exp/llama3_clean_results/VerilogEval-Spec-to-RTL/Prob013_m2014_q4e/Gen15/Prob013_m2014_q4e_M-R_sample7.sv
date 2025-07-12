module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Refactored implementation using logical operators
    assign out = ~(in1 | in2);
endmodule