module TopModule (
    input  in1,
    input  in2,
    output out
);

// Directly assign the NOR of inputs for minimal logic depth and clear intent
assign out = ~(in1 | in2);

endmodule