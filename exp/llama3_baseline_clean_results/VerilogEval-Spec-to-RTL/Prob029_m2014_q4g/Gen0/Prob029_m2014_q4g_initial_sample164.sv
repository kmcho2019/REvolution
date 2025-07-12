module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implementing the logic of the circuit
assign out = ~(in1 ^ in2) ^ in3;

endmodule