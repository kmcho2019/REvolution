module TopModule(
    input  in1,
    input  in2,
    output out
);

// Directly use the AND operation with one input inverted
assign out = in1 & (~in2);

endmodule