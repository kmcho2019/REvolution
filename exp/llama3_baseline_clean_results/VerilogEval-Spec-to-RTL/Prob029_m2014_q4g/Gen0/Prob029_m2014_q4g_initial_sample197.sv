module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implement XNOR gate using equality operator
wire xnor_out;
assign xnor_out = (in1 == in2);

// Implement XOR gate using bitwise XOR operator
assign out = xnor_out ^ in3;

endmodule