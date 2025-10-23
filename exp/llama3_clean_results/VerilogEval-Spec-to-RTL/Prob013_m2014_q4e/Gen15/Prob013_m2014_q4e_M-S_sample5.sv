module TopModule(
    input  in1,
    input  in2,
    output out
);

// Assign the output directly using the NOR operator
assign out = ~(in1 | in2);

endmodule