module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly assign NOR logic to output using a continuous assignment
    assign out = ~(in1 | in2);
endmodule