module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Optimal 2-input NOR gate implementation
    assign out = ~(in1 | in2);
endmodule