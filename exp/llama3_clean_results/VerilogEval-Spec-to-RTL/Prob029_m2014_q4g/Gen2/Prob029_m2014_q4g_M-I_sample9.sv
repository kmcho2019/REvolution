module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Combine XNOR and XOR operations
assign out = ~(in1 ^ in2) ^ in3;

// Alternatively, we can simplify the expression using Boolean algebra
// assign out = ((in1 == in2) ^ in3);

endmodule