module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly compute the output 'out' using a single assignment statement
assign out = !(in1 ^ in2) ^ in3;

endmodule