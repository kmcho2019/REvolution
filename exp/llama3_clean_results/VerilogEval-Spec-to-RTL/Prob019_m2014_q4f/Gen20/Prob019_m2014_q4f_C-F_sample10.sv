module TopModule(
    input  in1,
    input  in2,
    output out
);

// Direct implementation of the required logic using continuous assignment
assign out = in1 & (~in2);

endmodule