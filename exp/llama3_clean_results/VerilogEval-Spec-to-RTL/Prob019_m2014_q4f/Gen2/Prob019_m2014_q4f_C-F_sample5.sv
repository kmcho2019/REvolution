module TopModule(
    input  in1,
    input  in2,
    output out
);

// Directly compute the output 'out' by performing an AND operation
// between 'in1' and the inverted 'in2', ensuring clarity and efficiency.
assign out = in1 & (~in2);

endmodule