module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly calculate the output using a more optimized combination of logical operations
assign out = (in1 == in2) ^ in3;

endmodule