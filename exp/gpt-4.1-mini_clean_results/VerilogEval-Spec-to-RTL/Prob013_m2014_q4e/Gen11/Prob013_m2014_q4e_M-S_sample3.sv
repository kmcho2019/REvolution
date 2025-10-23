module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly implement 2-input NOR gate using assign
    assign out = ~(in1 | in2);
endmodule